#ifndef PROCESS_H
#define PROCESS_H

#include <qprocess.h>
#include <qtmetamacros.h>
#pragma once

#include <QObject>
#include <QProcess>

class Process : public QObject {
    Q_OBJECT
    Q_PROPERTY(QStringList command READ command WRITE setCommand NOTIFY commandChanged)
    Q_PROPERTY(QString stdout READ stdout NOTIFY stdoutChanged)

  public:
    explicit Process(QObject *parent = nullptr);
    QString stdout() const { return m_stdout; }

    ~Process() override;

    // Disable copy and assignment
    Process(const Process&) = delete;
    Process& operator=(const Process&) = delete;

  signals:
    void commandChanged();
    void stdoutChanged();

  public slots:
    //

  private:
    QStringList m_command;
    QString m_stdout;
    QStringList command() const { return m_command; }
    void setCommand(const QStringList &command);
    void runCommand();
    void cleanup();
    QString m_stdoutBuffer;
    QProcess *m_process = nullptr;
};

#endif
