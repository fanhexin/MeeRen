#include "touchapplicationviewer.h"
#include "multitouch.h"

#include <QMouseEvent>

TouchApplicationViewer::TouchApplicationViewer(MultiTouch* touch, QWidget *parent) :
    QmlApplicationViewer(parent), m_touch(touch)
{
    qmlRegisterType<TouchPoint>("Multitouch", 1, 0, "TouchPoint");
}

bool TouchApplicationViewer::viewportEvent(QEvent *event)
{
    if (!m_touch)
    {
        return QDeclarativeView::viewportEvent(event);
    }

    switch (event->type())
    {
    case QEvent::TouchBegin:
    case QEvent::TouchUpdate:
    case QEvent::TouchEnd:
        return m_touch->update(*(static_cast<QTouchEvent *>(event)));
       // return true;
    default:
        return QDeclarativeView::viewportEvent(event);
    } 
}
