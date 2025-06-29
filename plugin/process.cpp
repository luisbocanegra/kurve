#include "process.h"
#include <QDebug>
#include <QSet>
#include <qcontainerfwd.h>

Process::Process(QObject *parent) : QObject(parent), m_command(), m_stdout(), m_stderr(), m_stdoutBuffer() {
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
    
    cleanup();

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
        m_process->disconnect();
        m_process->deleteLater();
        m_process = nullptr;
    }
}
