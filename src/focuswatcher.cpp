#include "focuswatcher.h"
#include <X11/Xutil.h>

FocusWatcher::FocusWatcher(QObject *parent) : QObject(parent)
{
    display = XOpenDisplay(NULL);
    lastFocusedWindow = None;
    
    timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &FocusWatcher::checkFocus);
}

FocusWatcher::~FocusWatcher()
{
    if (display) {
        XCloseDisplay(display);
    }
}

void FocusWatcher::start()
{
    timer->start(200);
}

void FocusWatcher::stop()
{
    timer->stop();
}

void FocusWatcher::checkFocus()
{
    if (!display) return;
    
    Window focusedWindow;
    int revert_to;
    XGetInputFocus(display, &focusedWindow, &revert_to);
    
    if (focusedWindow != lastFocusedWindow && lastFocusedWindow != None) {
        emit focusChanged();
    }
    
    lastFocusedWindow = focusedWindow;
}
