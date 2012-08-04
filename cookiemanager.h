#ifndef COOKIEMANAGER_H
#define COOKIEMANAGER_H

#include <QObject>
#include <QDeclarativeEngine>
#include <QtNetwork/QNetworkAccessManager>
#include <QtNetwork/QNetworkCookieJar>
#include <QDebug>

class CookieManager : public QObject
{
    Q_OBJECT
public:
    explicit CookieManager(QDeclarativeEngine *declarativeEngine, QObject *parent = 0);
    
signals:
    
public slots:
    Q_INVOKABLE void clearCookies();

private:
    QDeclarativeEngine* m_declarativeEngine;
};

#endif // COOKIEMANAGER_H
