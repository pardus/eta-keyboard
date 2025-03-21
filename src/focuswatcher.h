#ifndef FOCUSWATCHER_H
#define FOCUSWATCHER_H

#include <QObject>
#include <QTimer>
#include <X11/Xlib.h>

class FocusWatcher : public QObject
{
    Q_OBJECT
public:
    explicit FocusWatcher(QObject *parent = nullptr);
    ~FocusWatcher();
    
    void start();
    void stop();
    
signals:
    void focusChanged();
    
private slots:
    void checkFocus();
    
private:
    QTimer *timer;
    Display *display;
    Window lastFocusedWindow;
};

#endif // FOCUSWATCHER_H 