QT += qml quick widgets dbus x11extras network svg

TARGET = eta-keyboard
TEMPLATE = app

SOURCES += src/xwrapper.cpp \
    src/xkblibwrapper.cpp \
    src/vkdbusinterface.cpp \
    src/singleinstance.cpp \
    src/settings.cpp \
    src/main.cpp \
    src/helper.cpp \
    src/adaptor.cpp \
    src/logger.cpp

RESOURCES += qml.qrc images.qrc

HEADERS += src/xwrapper.h \
    src/xkblibwrapper.h \
    src/vkdbusinterface.h \
    src/singleinstance.h \
    src/settings.h \
    src/helper.h \
    src/adaptor.h \
    src/logger.h

LIBS += -lxcb -lxkbcommon -lxkbcommon-x11 -lX11 -lXtst -lxcb-xkb

CONFIG+=declarative_debug qml_debug

target.path = /usr/bin/

desktop_file.files = eta-keyboard.desktop
desktop_file.path = /usr/share/applications/

autostart_file.files = eta-keyboard-autostart.desktop
autostart_file.path = /etc/xdg/autostart/

icon.files = eta-keyboard.svg
icon.path = /usr/share/icons/hicolor/scalable/apps/

icon_project.files = keyboard.svg
icon_project.path = /usr/share/eta/eta-keyboard/

atspi_env.files = atspi/99eta-a11y
atspi_env.path = /etc/X11/Xsession.d
tif.files = atspi/eta-tif
tif.path = /usr/bin
tif_desktop.files = atspi/eta-tif-autostart.desktop
tif_desktop.path = /etc/xdg/autostart

INSTALLS += target desktop_file autostart_file icon icon_project atspi_env tif tif_desktop
