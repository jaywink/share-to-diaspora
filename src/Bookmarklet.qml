import QtQuick 2.0
import Ubuntu.Web 0.2


WebView {
    property string shareUrl: ""
    property string shareTitle: ""
    property string browserUA: "Mozilla/5.0 (Ubuntu; Mobile) WebKit/537.21"

    id: webview
    anchors {
        fill: parent
        bottom: parent.bottom
    }
    width: parent.width
    height: parent.height

    // Unfortunately while we try to use `title` here, due to bug https://bugs.launchpad.net/ubuntu/+source/webbrowser-app/+bug/1571361
    // it isn't transferred from webbrowser-app at this moment.
    url: "https://%domain%/bookmarklet/?url=%url%&title=%title%".replace("%domain%", config.contents.podDomain).replace("%url%", encodeURI(shareUrl)).replace("%title%", encodeURI(shareTitle));
    preferences.localStorageEnabled: true
    preferences.appCacheEnabled: true
    preferences.javascriptCanAccessClipboard: true

    onLoadEvent: {
        // Close app once we're done
        var url = String(webview.url);
        if (url.indexOf("/bookmarklet") === -1 && url.indexOf("/users/sign_in") === -1) {
            Qt.quit()
        }
    }
}

