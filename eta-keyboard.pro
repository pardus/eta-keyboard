TEMPLATE = app

QT += qml quick widgets dbus x11extras

SOURCES += main.cpp \
    helper.cpp \
    xwrapper.cpp \
    vkdbusinterface.cpp \
    adaptor.cpp \
    xkblibwrapper.cpp

RESOURCES += qml.qrc images.qrc

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    helper.h \
    xwrapper.h \
    vkdbusinterface.h \
    adaptor.h \
    xkblibwrapper.h
LIBS += -lxcb -lxkbcommon -lxkbcommon-x11 -lX11 -lXtst -lxcb-xkb

