import 'package:flutter/material.dart';
import 'package:flutter_application_liamtest/env.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const WebViewContainer({super.key, required this.navigatorKey});

  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  late final WebViewController controller;

  // Set up the WebViewController to open the initial PayPal DriveU
  // page and set up a listener to see when the payment has been 'complete'
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(BASE_URL))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            print("The url is: $url");
            if (url == '$BASE_URL/after-approval') {
              widget.navigatorKey.currentState?.pop();
              // Navigate to the AfterApprovalScreen
              widget.navigatorKey.currentState?.pushNamed('/requestSubmitted');
            }
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PayU"),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
