import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Content 1.1
import Ubuntu.Web 0.2
import com.canonical.Oxide 1.9 as Oxide
import QtQuick.Window 2.2


Window {
    id: window
    visibility: Window.AutomaticVisibility

    property string baseUrl: "https://iliketoast.net"
    property string bookmarkletPath: "/bookmarklet/?url=%url%&title=%title%"
    property string browserUA: "Mozilla/5.0 (Ubuntu; Mobile) WebKit/537.21"

    width: units.gu(150)
    height: units.gu(100)

    MainView {
        objectName: "mainView"
        applicationName: "share-to-diaspora.jaywink"

        anchorToKeyboard: true
        automaticOrientation: true
        useDeprecatedToolbar: false

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        Page {
            anchors {
                fill: parent
                bottom: parent.bottom
            }
            width: parent.width
            height: parent.height

            WebView {
                id: webview
                anchors {
                    fill: parent
                    bottom: parent.bottom
                }
                width: parent.width
                height: parent.height

                url: baseUrl
                preferences.localStorageEnabled: true
                preferences.appCacheEnabled: true
                preferences.javascriptCanAccessClipboard: true
                onFullscreenRequested: webview.fullscreen = fullscreen
            }

            Connections {
                target: ContentHub
                onShareRequested: {
                    webview.url = baseUrl + bookmarkletPath.replace("%url%", encodeURI(String(transfer.items[0].url))).replace("%title%", encodeURI(String(transfer.items[0].name)))
                }
            }
        }
    }
}
