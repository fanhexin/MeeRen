#include "multitouch.h"

#include <QPoint>
#include <QMouseEvent>

void TouchPoint::setX(const int x)
{
    if (x != m_x)
    {
        m_x = x;
        emit xChanged();
    }
}

void TouchPoint::setY(const int y)
{
    if (y != m_y)
    {
        m_y = y;
        emit yChanged();
    }
}

void TouchPoint::set(const int x, const int y)
{
    setX(x);
    setY(y);
}

MultiTouch::MultiTouch(QObject *parent) :
    QObject(parent)
{
    lastScale = 1;
}

MultiTouch::~MultiTouch()
{
    clear();
}

void MultiTouch::clear()
{
    while (!m_touch.isEmpty())
        delete m_touch.takeFirst();
}

void MultiTouch::clearLastScale()
{
    lastScale = 1;
}

bool MultiTouch::update(QTouchEvent& event)
{
    switch (event.type()) {
        case QEvent::TouchBegin:
        case QEvent::TouchUpdate:
        case QEvent::TouchEnd:
        {
            QTouchEvent *touchEvent = &event;
            QList<QTouchEvent::TouchPoint> touchPoints = touchEvent->touchPoints();
            if (touchPoints.count() == 2) {
                // determine scale factor
                const QTouchEvent::TouchPoint &touchPoint0 = touchPoints.first();
                const QTouchEvent::TouchPoint &touchPoint1 = touchPoints.last();
                qreal currentScale = QLineF(touchPoint0.pos(), touchPoint1.pos()).length()/QLineF(touchPoint0.startPos(), touchPoint1.startPos()).length();
                qreal currentScaleFactor = lastScale*currentScale;
                if (currentScaleFactor < 1) currentScaleFactor = 1;

                if (touchEvent->touchPointStates() & Qt::TouchPointReleased) {
                    // if one of the fingers is released, remember the current scale
                    // factor so that adding another finger later will continue zooming
                    // by adding new scale factor to the existing remembered value.
                    lastScale = currentScaleFactor;
                }

                emit scaleFactor(currentScaleFactor);
                return false;
            }else {
                return true;
            }
            break;
        }
        default:
            return true;
            break;
    }
}
