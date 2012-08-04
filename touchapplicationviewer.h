#ifndef TOUCHAPPLICATIONVIEWER_H
#define TOUCHAPPLICATIONVIEWER_H

#include "qmlapplicationviewer.h"

class MultiTouch;

class TouchApplicationViewer : public QmlApplicationViewer
{
    Q_OBJECT

public:
    explicit TouchApplicationViewer(MultiTouch* touch, QWidget *parent = 0);
    bool viewportEvent(QEvent *event);

signals:

public slots:

private:
    MultiTouch* m_touch;
};

#endif // TOUCHAPPLICATIONVIEWER_H
