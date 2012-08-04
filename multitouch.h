#ifndef MULTITOUCH_H
#define MULTITOUCH_H

#include <QObject>
#include <QList>
#include <QTouchEvent>
#include <QtDeclarative>

class TouchPoint : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int x READ x WRITE setX NOTIFY xChanged)
    Q_PROPERTY(int y READ y WRITE setY NOTIFY yChanged)

public:
    TouchPoint(QObject *parent = 0) : QObject(parent), m_x(0), m_y(0) {};
    ~TouchPoint() {};

    int x() { return m_x; };
    int y() { return m_y; };

public slots:
    void setX(const int x);
    void setY(const int y);
    void set(const int x, const int y);

signals:
    void xChanged();
    void yChanged();

private:
    int m_x;
    int m_y;
};

class MultiTouch : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QDeclarativeListProperty<TouchPoint> touchPoints READ touchPoints NOTIFY touchPointsChanged);
    QDeclarativeListProperty<TouchPoint> touchPoints() {return QDeclarativeListProperty<TouchPoint>(this, m_touch);}

public:
    explicit MultiTouch(QObject *parent = 0);
    ~MultiTouch();

    bool update(QTouchEvent& touchEvent);
    void clear();

signals:
    void touchPointsChanged();
    void scaleFactor(const QVariant&);
public slots:
    void clearLastScale();
private:
    QList<TouchPoint*> m_touch;
    qreal lastScale;
};

QML_DECLARE_TYPE(TouchPoint)

#endif // MULTITOUCH_H
