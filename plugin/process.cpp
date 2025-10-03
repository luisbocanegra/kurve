#include "process.h"
#include <QDebug>
#include <QTimer>
#include <qdebug.h>
#include <qprocess.h>

Process::Process(QObject *parent) : QObject(parent), m_command(), m_stdout(), m_stderr(), m_running(), m_stdoutBuffer() {
    connect(this, &Process::commandChanged, this, &Process::restart);
}

Process::~Process() = default;

void Process::setCommand(const QStringList &newCommand) {

    if (m_command != newCommand) {
        m_command = newCommand;
        emit commandChanged();
    }
}

void Process::restart() {
    if (m_command.isEmpty()) {
        qWarning() << "Command is empty, cannot run.";
        return;
    }

    stop();

    m_process = new QProcess(this);
    m_process->start(m_command.first(), m_command.mid(1));

    connect(m_process, &QProcess::stateChanged, this, [this](QProcess::ProcessState state) {
        bool runningNow = (state == QProcess::Running);
        if (m_running != runningNow) {
            m_running = runningNow;
            emit runningChanged();
            if (m_running) {
                m_stderr = "";
                emit stderrChanged();
            }
        }
    });

    connect(m_process, &QProcess::readyReadStandardOutput, this, [this]() {
        m_stdoutBuffer += QString::fromUtf8(m_process->readAllStandardOutput());
        qsizetype newlineIndex;
        while ((newlineIndex = m_stdoutBuffer.indexOf('\n')) != -1) {
            QString line = m_stdoutBuffer.left(newlineIndex).trimmed();
            m_stdoutBuffer = m_stdoutBuffer.mid(newlineIndex + 1);
            if (!line.isEmpty()) {
                m_stdout = line;
                emit stdoutChanged();
            }
        }
    });
    connect(m_process, &QProcess::readyReadStandardError, this, [this]() {
        QString stderr = QString::fromUtf8(m_process->readAllStandardError());
        if (!stderr.isEmpty() && stderr != m_stderr) {
            m_stderr = stderr;
            emit stderrChanged();
        }
    });
    connect(m_process, &QProcess::finished, this, [this]() {
        cleanup();
    });

    connect(m_process, &QProcess::errorOccurred, this, [this]() {
        cleanup();
    });
    }

void Process::cleanup() {
    if (m_process) {
        m_process->disconnect();
        m_process->deleteLater();
        m_process = nullptr;
    }
}

void Process::stop() {
    if (m_process) {
        QProcess proc;
        proc.start("pgrep", {"-P", QString::number(m_process->processId())});
        proc.waitForFinished();
        QString output = proc.readAllStandardOutput();
        QStringList pidList = output.split('\n', Qt::SkipEmptyParts);
        for (const QString &pid : pidList) {

            QProcess kill_proc;
            kill_proc.start("kill", {"-TERM", pid});
            kill_proc.waitForFinished();
        }
        m_process->terminate();
        m_process->waitForFinished();
    }
}
