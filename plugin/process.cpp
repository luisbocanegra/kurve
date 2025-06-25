#include "process.h"
#include <QDebug>
#include <QSet>
#include <qcontainerfwd.h>

Process::Process(QObject *parent) : QObject(parent), m_command(), m_stdout(), m_stdoutBuffer() {
    connect(this, &Process::commandChanged, this, &Process::runCommand);
}

Process::~Process() = default;

void Process::setCommand(const QStringList &newCommand) {

    if (m_command != newCommand) {
        m_command = newCommand;
        emit commandChanged();
    }
}

void Process::runCommand() {
    if (m_command.isEmpty()) {
        qWarning() << "Command is empty, cannot run.";
        return;
    }
    if (m_process) {
        m_process->terminate();

        if (!m_process->waitForFinished()) {
            qWarning() << "Process didn't finish in time, killing it.";
            m_process->kill();
        }

        m_process->deleteLater();
        m_process = nullptr;
    }

    QProcess* proc = m_process;
    m_process = new QProcess(this);
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
    connect(proc, &QProcess::finished, this, [this, proc](int exitCode, QProcess::ExitStatus exitStatus) {
        if (proc != m_process) return;
        qDebug() << "Process finished:" << exitCode << exitStatus;
        cleanup();
    });

    connect(proc, &QProcess::errorOccurred, this, [this, proc](QProcess::ProcessError error) {
        if (proc != m_process) return;
        qWarning() << "Process error occurred:" << error;
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
