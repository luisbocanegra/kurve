#include "process.h"
#include <QDebug>
#include <QTimer>
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
    
    cleanup();

    m_process = new QProcess(this);

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

    m_process->start(m_command.first(), m_command.mid(1));

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
    connect(m_process, &QProcess::finished, this, [this](int exitCode, QProcess::ExitStatus exitStatus) {
        qDebug() << "Process finished:" << exitCode << exitStatus;
        cleanup();
    });

    connect(m_process, &QProcess::errorOccurred, this, [this](QProcess::ProcessError error) {
        qWarning() << "Process error occurred:" << error;
        cleanup();
    });
    }

void Process::cleanup() {
    if (m_process) {
        qDebug() << "Running cleanup:";
        m_process->disconnect();
        m_process->deleteLater();
        m_process = nullptr;
    }
}

void Process::stop() {
    if (m_process && m_running) {
        QProcess *proc = m_process;
        proc->terminate();
        QTimer::singleShot(3000, this, [this, proc]() {
            if (m_process == proc && m_process->state() != QProcess::NotRunning) {
                m_process->kill();
            }
        });
    }
}
