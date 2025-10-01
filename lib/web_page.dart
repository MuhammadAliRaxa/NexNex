

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {

  bool isLoading=false;

  final GlobalKey webViewKey = GlobalKey();

  bool networkAvailable=true;

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(isInspectable: kDebugMode,mediaPlaybackRequiresUserGesture: false,allowsInlineMediaPlayback: true,allowsAirPlayForMediaPlayback: true,geolocationEnabled: true,
    allowContentAccess: true,
    supportMultipleWindows: true,  
    javaScriptCanOpenWindowsAutomatically: true,  
    limitsNavigationsToAppBoundDomains: true,
        javaScriptEnabled: true,
        userAgent: Platform.isAndroid
          ? "Mozilla/5.0 (Linux; Android 13; Pixel 6) AppleWebKit/537.36 "
            "(KHTML, like Gecko) Chrome/115.0.0.0 Mobile Safari/537.36"
          : "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) "
            "AppleWebKit/605.1.15 (KHTML, like Gecko) "
            "Version/16.0 Mobile/15E148 Safari/604.1",
        cacheMode: CacheMode.LOAD_DEFAULT,
        mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,);
  PullToRefreshController? pullToRefreshController;
  PullToRefreshSettings pullToRefreshSettings = PullToRefreshSettings(
    color: Colors.blue,
  );
  bool pullToRefreshEnabled = true;


  @override
  void initState() {
    super.initState();
    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: pullToRefreshSettings,
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if(webViewController!=null){
          if(await webViewController!.canGoBack()){
            await webViewController!.goBack();
          }
        }
      },
      child: Scaffold(
          body: SafeArea(
            child: Stack(children: <Widget>[
              InAppWebView(
              key: webViewKey,
              initialUrlRequest:
                  URLRequest(url: WebUri("https://NexNex.site/")),
              initialSettings: settings,
              onPermissionRequest: (controller, permissionRequest) async{
                return PermissionResponse(
                  resources: permissionRequest.resources,
                  action:PermissionResponseAction.GRANT
                );
              },
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (InAppWebViewController controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  isLoading=true;
                });
              },
              onLoadStop: (controller, url) {
                setState(() {
                  isLoading=false;
                });
                pullToRefreshController?.endRefreshing();
              },
              onReceivedError: (controller, request, error) {
                pullToRefreshController?.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController?.endRefreshing();
                }
              },
                            ),
                            if (isLoading)
            const Center(
              child: SpinKitFadingCircle(
  color: Colors.deepPurple,
  size: 50.0,
),
            ),
            ]),
          )),
    );
  }
}
