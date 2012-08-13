#include <QtGui/QApplication>
#include <QtDeclarative>
#include "touchapplicationviewer.h"
#include "multitouch.h"
#include "cookiemanager.h"
#include "settings.h"
//#include <meventfeed.h>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(createApplication(argc, argv));

    //QmlApplicationViewer viewer;
    //qmlRegisterType<MyWebView>("mylib", 1, 0, "MyWebView");


    MultiTouch touch;
    TouchApplicationViewer viewer(&touch);
    viewer.rootContext()->setContextProperty("multitouch", &touch);

    QSettings setting("IndependentSoft", "MeeRen");
    Settings config(&setting);
    viewer.rootContext()->setContextProperty("setting", &config);

    CookieManager* cm = new CookieManager(viewer.engine(), &viewer);
    viewer.rootContext()->setContextProperty("cm", cm);

    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qml/MeeRen/main.qml"));

    QObject *rootObject = (QObject*)viewer.rootObject();
    QObject::connect(&touch, SIGNAL(scaleFactor(const QVariant&)),
             rootObject, SLOT(scaleChanged(const QVariant&)));
//    QObject::connect(rootObject, SIGNAL(initScale(const QVariant&)),
//                     &touch, SLOT(clearLastScale(QVariant)));
    viewer.showExpanded();
//    MEventFeed::instance()->addItem(QString("icon name"),
//                           QString("title text"),
//                           QString("body text"),
//                                    QStringList(""),
//                           QDateTime::currentDateTime(),
//                           QString("footer text"),
//                           false,
//                           QUrl("http://www.myurl.com/"),
//                           QString("ApplicationID"),
//                           QString("ApplicationID_Name"));

    return app->exec();
}
