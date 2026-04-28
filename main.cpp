#include <QGuiApplication> // 引入Qt GUI应用核心类，提供事件循环等功能
#include <QQmlApplicationEngine> // 引入QML引擎，用于加载运行QML文件
#include <QQmlContext>
#include "CPP/MusicController.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling); // 开启高分屏缩放适配，保证在高分辨率屏幕下UI不偏小
#endif
    QGuiApplication app(argc, argv); // 实例化QGuiApplication，管理GUI程序的控制流和主要设置

    QQmlApplicationEngine engine; // 实例化QML引擎对象，它结合了QJSEngine和QQmlComponent，可以直接加载QML界面

    // 实例化 Controller
    MusicController musicController;
    // 注入为 QML 全局上下文变量 "MusicCtrl"
    engine.rootContext()->setContextProperty("MusicCtrl", &musicController);

    const QUrl url(QStringLiteral("qrc:/main.qml")); // 定义入口QML文件路径
    
    // 注册QML单例类型，使得`Style.qml`可以作为一个名为Style的全局单例对象在其他QML代码中直接被访问（例如`Style.color`）
    qmlRegisterSingletonType(QUrl(QStringLiteral("qrc:/Style.qml")), "Style", 1, 0, "Style");
    
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            // 当引擎加载对象完毕后的回调。如果目标QML没有成功创建根对象，应用则以错误码退出
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection); // 保证退出操作在当前事件处理完毕后安全执行
        
    engine.load(url); // 让引擎开始加载入口指定的main.qml文件，从而显示UI

    return app.exec(); // 进入应用程序主事件循环，等待鼠标、键盘和定时器等各类事件发生
}
