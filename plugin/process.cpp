#include "process.h"
#include <QDebug>
#include <QTimer>

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
    qDebug() << "Restarting process:" << m_command;
    if (m_command.isEmpty()) {
        qWarning() << "Command is empty, cannot run.";
        return;
    }

    QProcess *old_proc = m_process;
    if (old_proc) {
        if (old_proc->state() != QProcess::NotRunning) {
            old_proc->kill();
        }
        cleanup(old_proc);
    }

    m_process = new QProcess(this);
    QProcess *proc = m_process;
    proc->start(m_command.first(), m_command.mid(1));

    connect(proc, &QProcess::stateChanged, this, [this](QProcess::ProcessState state) {
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

    connect(proc, &QProcess::readyReadStandardOutput, this, [this, proc]() {
        m_stdoutBuffer += QString::fromUtf8(proc->readAllStandardOutput());
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

    connect(proc, &QProcess::readyReadStandardError, this, [this, proc]() {
        QString stderr = QString::fromUtf8(proc->readAllStandardError());
        if (!stderr.isEmpty() && stderr != m_stderr) {
            m_stderr = stderr;
            emit stderrChanged();
        }
    });

    connect(proc, &QProcess::finished, this, [this, proc]() {
        cleanup(proc);
    });

    connect(proc, &QProcess::errorOccurred, this, [this, proc]() {
        cleanup(proc);
    });
}

void Process::cleanup(QProcess *proc) {
    qDebug() << "Cleaning up process";
    if (!proc) return;
    proc->disconnect();
    if (m_process == proc) m_process = nullptr;
    proc->deleteLater();
}

void Process::stop() {
    if (m_process && m_process->state() != QProcess::NotRunning) {
        qDebug() << "Stopping process" << m_process->processId() << m_command;
        m_process->kill();
        m_process->waitForFinished();
    }
}
