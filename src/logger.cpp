#include "logger.h"
#include <QDir>
#include <QDateTime>
#include <QtWidgets>
#include <QFile>
#include <QFileInfo>
#include <QTextStream>
#include <QCoreApplication>

#define log_file_path "/var/log"
#define log_file_name "eta.log"

Logger::Logger(QObject *parent) : QObject(parent)
{
    m_path = QCoreApplication::applicationFilePath();

    QStringList homePath =
            QStandardPaths::standardLocations(QStandardPaths::HomeLocation);
    whoami = homePath.first().split(QDir::separator()).last();

}

QString Logger::getPath() const
{
    return m_path;
}

QString Logger::getUser() const
{
    return whoami;
}

void Logger::log(const QString &str)
{
    createFile(log_file_path, log_file_name);
    file.setFileName(file_fullpath);
    if (file.open(QIODevice::WriteOnly | QIODevice::Append)){
        if (writeData(str)) {
            file.close();
        }
        else qDebug() << "Log information could not write to log file";
    } else {
        qDebug() << "Log information could not open";
    }
}

bool Logger::createFile(const QString &file_path, const QString &file_name)
{
    file_fullpath = file_path + "/" + file_name;
    QFileInfo checkFile(file_fullpath);
    d = new QDir(file_path);
    if(!checkFile.exists() || !checkFile.isFile()) {
        d->mkpath(file_path);
        QFile file(file_fullpath);
        if (file.open(QIODevice::ReadWrite)) {
            file.setPermissions(QFileDevice::ReadOther |
                                QFileDevice::WriteOther |
                                QFileDevice::ReadGroup |
                                QFileDevice::WriteGroup |
                                QFileDevice::ReadOwner |
                                QFileDevice::WriteOwner |
                                QFileDevice::ExeOwner);
            file.close();
            return true;
        } else {
            qDebug() << file.errorString();
        }
    }
    return false;

}

void Logger::updateTime()
{
    QDateTime now = QDateTime::currentDateTime();
    m_current_time = now.toString("dd-MM-yyyy hh:mm:ss.zzz");
}

bool Logger::writeData(const QString &str)
{
    try {
        updateTime();
        QTextStream out(&file);
        out << m_current_time + " " + yellow_color + getPath() + no_color + " : " + str + "\n";
        return true;
    } catch (...) {
        return false;
    }
}
