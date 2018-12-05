#ifndef LOGGER_H
#define LOGGER_H

#include <QObject>
#include <QString>
#include <QFile>

class QDir;

class Logger : public QObject
{
    Q_OBJECT
public:
    explicit Logger(QObject *parent = 0);

    QString getPath() const;
    QString getUser() const;
    void log(const QString &str);

    QString red_color = "\033[1;31m";
    QString yellow_color = "\033[1;33m";
    QString green_color = "\033[1;32m";
    QString no_color = "\033[0m";

private:
    QString m_current_time;
    QString m_path;
    QString file_fullpath;
    QString whoami;

    QDir *d;
    QFile file;


    bool createFile(const QString &file_path, const QString &file_name);
    void updateTime();
    bool writeData(const QString &str);
};

#endif // LOGGER_H
