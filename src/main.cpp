/*****************************************************************************
 *   Copyright (C) 2016 by Yunusemre Senturk                                 *
 *   <yunusemre.senturk@pardus.org.tr>                                       *
 *                                                                           *
 *   This program is free software; you can redistribute it and/or modify    *
 *   it under the terms of the GNU General Public License as published by    *
 *   the Free Software Foundation; either version 2 of the License, or       *
 *   (at your option) any later version.                                     *
 *                                                                           *
 *   This program is distributed in the hope that it will be useful,         *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 *   GNU General Public License for more details.                            *
 *                                                                           *
 *   You should have received a copy of the GNU General Public License       *
 *   along with this program; if not, write to the                           *
 *   Free Software Foundation, Inc.,                                         *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .          *
 *****************************************************************************/
#include "src/helper.h"
#include "src/singleinstance.h"
#include <signal.h>
#include <unistd.h>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QDir>
#include <QCursor>
#include <X11/Xlib.h>
#include <X11/Xatom.h>
#include <X11/Xresource.h>
#include <QQmlContext>
#include <QScreen>
#include <QGuiApplication>
#include <QRect>
#include <QDesktopWidget>
#include <QDebug>

#define SINGLE_INSTANCE ".virtualkeyboard"
static int setup_unix_signal_handlers();

int main(int argc, char *argv[])
{
    if (argc == 2 && QString(argv[1]) == "login") {
        Helper::login = true;
    } else if (argc == 2 && QString(argv[1]) == "show") {
        Helper::showOnStart = true;
    }

    qmlRegisterType<Helper>("eta.helper",1,0,"Helper");

    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    // app.setOverrideCursor(QCursor(Qt::BlankCursor));

    QString pidName = SINGLE_INSTANCE;
    QString username = qgetenv("USER");
    if (username.isEmpty())
        username = qgetenv("USERNAME");
    QString tmpPath= "/tmp/";
    QString pidPath = tmpPath.append(username);


    QDir dir(pidPath);
    if (!dir.exists()) {
        dir.mkpath(".");
    }

    QString name = pidPath.append("/").append(pidName);

    SingleInstance cInstance;

    if(cInstance.hasPrevious(name, QCoreApplication::arguments()))
    {
        if (argc == 2 && QString(argv[1]) == "show") {
            qDebug("Trying to show");
            return system("qdbus org.eta.virtualkeyboard /VirtualKeyboard "
                          "org.eta.virtualkeyboard.showForce false");
        } else {
            qDebug("eta-keyboard is allready running");
            return 0;
        }

    }

    if (cInstance.listen(name)) {
        qDebug() << "Creating single instance";
        setup_unix_signal_handlers();
    } else {
        qFatal("Couldn't create single instance aborting");
    }

    QQmlApplicationEngine engine;

    QScreen *screen = QGuiApplication::primaryScreen();

    // Expose screen object to QML
    engine.rootContext()->setContextProperty("screen", screen);

    // Expose DPI value to QML
    engine.rootContext()->setContextProperty("dpiValue",
                                             qApp->desktop()->logicalDpiX());

    engine.load(QUrl(QStringLiteral("qrc:/ui/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    QObject::connect(screen, &QScreen::geometryChanged, [&engine](const QRect &geometry){
        QVariant returnedValue;
        QVariant msg = geometry;
        QMetaObject::invokeMethod(engine.rootObjects().first(), "updateScreenGeometry",
                                  Q_RETURN_ARG(QVariant, returnedValue),
                                  Q_ARG(QVariant, msg));
    });

    return app.exec();
}

static void handle_signal(int sig)
{
    QString pidName = SINGLE_INSTANCE;
    QString username = qgetenv("USER");
    if (username.isEmpty())
        username = qgetenv("USERNAME");
    QString tmpPath= "/tmp/";
    QString pidPath = tmpPath.append(username);
    QString name = pidPath.append("/").append(pidName);
    QByteArray ba = name.toLatin1();
    Q_UNUSED(sig);
    unlink(ba.data());
    exit(0);
}

static int setup_unix_signal_handlers()
{
    struct sigaction sig;
    sig.sa_handler = handle_signal;
    sigemptyset(&sig.sa_mask);
    sig.sa_flags = 0;
    sig.sa_flags |= SA_RESTART;
    if (sigaction(SIGINT, &sig, 0)) {
        return 1;
    }
    if (sigaction(SIGTERM, &sig, 0)) {
        return 2;
    }
    return 0;
}
