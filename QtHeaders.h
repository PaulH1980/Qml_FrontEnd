#pragma once

#define  GLEW_STATIC 
#include <Glew/glew.h>

#include <QtCore/QMetaType>
#include <QtCore/QtGlobal>
#include <QtCore/QMutex>
#include <QtCore/QMutexLocker>
#include <QtCore/QHash>
#include <QtCore/QThread>
#include <QtCore/QObject>
#include <QtCore/QVariantMap>
#include <QtCore/QTimer>
#include <QtCore/QtDebug>
#include <QtCore/QDir>
#include <QtCore/QFileInfo>
#include <QtCore/QJsonObject>
#include <QtCore/QJsonDocument>
#include <QtCore/QJsonArray>
#include <QtCore/QFileSystemWatcher>
#include <QtCore/QDateTime>
#include <QtCore/QAbstractListModel>

#include <QtCore/QList>
#include <QtCore/QStringBuilder>
#include <QtCore/QStringList>
#include <QtCore/QMetaType>
#include <QtCore/QDebug>



#include <QtWidgets/QGraphicsView>
#include <QtWidgets/QGraphicsScene>
#include <QtWidgets/QTreeView>
#include <QtWidgets/QApplication>
#include <QtWidgets/QFileDialog>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QOpenGLWidget>
#include <QtWidgets/QMessageBox>

#include <QtOpenGL/QGLFunctions>

#include <QtGui/QOpenGLFramebufferObjectFormat>
#include <QtGui/QOpenGLFunctions_4_3_Core>
#include <QtGui/QOpenGLFunctions_3_3_Core>
#include <QtGui/QOpenGLFunctions_3_3_Compatibility>
#include <QtGui/QOpenGLFunctions_4_3_Compatibility>
#include <QtGui/QOpenGLFunctions_4_4_Compatibility>
#include <QtGui/QOpenGLFunctions_4_4_Core>
#include <QtGui/QOpenGLFunctions_4_5_Compatibility>
#include <QtGui/QOpenGLFunctions_4_5_Core>
#include <QtGui/QSurfaceFormat>
#include <QtGui/QOpenGLShaderProgram>
#include <QtGui/QOpenGLBuffer>
#include <QtGui/QOpenGLShader>
#include <QtGui/QOpenGLContext>
#include <QtGui/QOpenGLWindow>

#include <QtGui/QStandardItemModel>

#include <QtGui/QGuiApplication>
#include <QtGui/QWheelEvent>
#include <QtGui/QMouseEvent>
#include <QtGui/QKeyEvent>
#include <QtGui/QResizeEvent>
#include <QtGui/QPixmap>

#include <QtQuick/QQuickPaintedItem>
#include <QtQuick/QQuickImageProvider>
#include <QtQuick/QQuickWindow>
#include <QtQuick/QQuickRenderControl>
#include <QtQuick/QQuickItem>
#include <QtQuick/QQuickFramebufferObject>
#include <QtQuick/QQuickView>
#include <QtQuickControls2/QQuickStyle>


#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlComponent>
#include <QtQml/QQmlContext>
#include <QtQml/QJSEngine>

using QRoleNames = QHash<int, QByteArray>;
static const QString EmptyQString = QString();