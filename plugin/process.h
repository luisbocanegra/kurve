#ifndef PROCESS_H
#define PROCESS_H

#pragma once

#include <QObject>
#include <QProcess>
#include <QStringList>
#include <QString>

class Process : public QObject {
    Q_OBJECT
    Q_PROPERTY(QStringList command READ command WRITE setCommand NOTIFY commandChanged)
    Q_PROPERTY(QString stdout READ stdout NOTIFY stdoutChanged)
    Q_PROPERTY(QString stderr READ stderr NOTIFY stderrChanged)
    Q_PROPERTY(bool running READ running NOTIFY runningChanged)

  public:
    explicit Process(QObject *parent = nullptr);
    QString stdout() const { return m_stdout; }
    QString stderr() const { return m_stderr; }
    bool running() const { return m_running; };
    Q_INVOKABLE void restart();
    Q_INVOKABLE void stop();

    ~Process() override;

    // Disable copy and assignment
    Process(const Process&) = delete;
    Process& operator=(const Process&) = delete;

  signals:
    void commandChanged();
    void stdoutChanged();
    void stderrChanged();
    void runningChanged();

  public slots:
    //

  private:
    QStringList m_command;
    QString m_stdout;
    QString m_stderr;
    bool m_running;
    QStringList command() const { return m_command; }
    void setCommand(const QStringList &command);
    void cleanup();
    QString m_stdoutBuffer;
    QProcess *m_process = nullptr;
};

#endif
