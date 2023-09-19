import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class WebViewWidget extends StatefulWidget {
   String webViewContents;

  WebViewWidget({super.key, required this.webViewContents});

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  WebViewPlusController? _controller;
  double _height = 1;

  @override
  Widget build(BuildContext context)=>
      widget.webViewContents.isEmpty ? Center(child:  CircularProgressIndicator(),) : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: double.maxFinite,
          height: _height,
          child: WebViewPlus(
            serverPort: 5353,
            javascriptChannels: null,
            initialUrl: 'about:blank',
            onWebViewCreated: (controller) {
              _controller = controller;
              final htmlContent = '''
                  <!DOCTYPE html>
                  <html>
                    <head>
                      <meta charset="UTF-8">
                      <meta name="viewport" content="width=device-width, initial-scale=1.0">
                      <style>
                        p {
                          color: #999999;
                          font-weight: 400;
                          line-height: 1.5;
                        }
                        body {
                          background-color: white;
                          font-family: Poppins, sans-serif;
                        }
                        li {
                          list-style: none;
                        }
                        b {
                          color: #1976D2FF;
                          letter-spacing: 1px;
                          font-size: 18px;
                        }
                         img {
                                    width: 100%;
                                    height: auto;
                                  }
                         span {
                  color: #999999;
                  font-weight: 400;
                  line-height: 24px;
                }
                      </style>
                    </head>
                    <body>
                      <div id="content"></div>
                      <script>
                        const contentDiv = document.getElementById('content');
                        contentDiv.innerHTML = '${widget.webViewContents}';
                      </script>
                    </body>
                  </html>
                ''';
              final uri = Uri.dataFromString(
                htmlContent,
                mimeType: 'text/html',
                encoding: utf8,
              );
              _controller?.loadUrl(uri.toString());
            },
            onPageFinished: (url) {
              _controller?.getHeight().then((double height) {
                setState(() {
                  _height = height;
                });
              });
            },
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
            gestureNavigationEnabled: true,
            onWebResourceError: (error) {
              print('Error loading page: $error');
            },
          ),
        ),
      );
}
class WebViewPlusAm extends StatefulWidget {
  String amharicContent;
   WebViewPlusAm({super.key, required this.amharicContent});

  @override
  State<WebViewPlusAm> createState() => _WebViewPlusAmState();
}
class _WebViewPlusAmState extends State<WebViewPlusAm> {
  WebViewPlusController? _controller;
  double _height = 1;
  @override
  Widget build(BuildContext context)=>
      widget.amharicContent.isEmpty ? Center(child: CircularProgressIndicator(),) :SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          width: double.maxFinite,
          height: _height,
          child: WebViewPlus(
            serverPort: 5353,
            javascriptChannels: null,
            initialUrl: 'about:blank',
            onWebViewCreated: (controller) {
              _controller = controller;
              final htmlContent = '''
                  <!DOCTYPE html>
                  <html>
                    <head>
                      <meta charset="UTF-8">
                      <meta name="viewport" content="width=device-width, initial-scale=1.0">
                      <style>
                        p {
                          color: #999999;
                          font-weight: 400;
                          line-height: 1.5;
                        }
                        
                        body {
                          background-color: white;
                          font-family: Poppins, sans-serif;
                        }
                        li {
                          list-style: none;
                        }
                                      img {
                                    width: 100%;
                                    height: auto;
                                  }
                        b {
                          color: #1976D2FF;
                          letter-spacing: 1px;
                          font-size: 18px;
                        }
                                 span {
                  color: #999999;
                  font-weight: 400;
                  line-height: 24px;
                }
                      </style>
                    </head>
                    <body>
                      <div id="content"></div>
                      <script>
                        const contentDiv = document.getElementById('content');
                        contentDiv.innerHTML = '${widget.amharicContent}';
                      </script>
                    </body>
                  </html>
                ''';
              final uri = Uri.dataFromString(
                htmlContent,
                mimeType: 'text/html',
                encoding: utf8,
              );
              _controller?.loadUrl(uri.toString());
            },
            onPageFinished: (url) {
              _controller?.getHeight().then((double height) {
                setState(() {
                  _height = height;
                });
              });
            },
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              return NavigationDecision.navigate;
            },
            gestureNavigationEnabled: true,
            onWebResourceError: (error) {
              print('Error loading page: $error');
            },
          ),
        ),
      );
}

class DoctorsEn extends StatefulWidget {
  String docsEn;
 DoctorsEn({super.key, required this.docsEn});

  @override
  State<DoctorsEn> createState() => _DoctorsEnState();
}

class _DoctorsEnState extends State<DoctorsEn> {
  WebViewPlusController? _controller;
  double _height = 1;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.maxFinite,
        height: _height,
        child: WebViewPlus(
          serverPort: 5353,
          javascriptChannels: null,
          onWebViewCreated: (controller) {
            _controller = controller;
            final htmlContent = """
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
              p {
               color: #999999;
                font-weight: 400;
      line-height: 24px;
              }
              body{
              background-color: white;
                font-family: Poppins, sans-serif;
              }
              li {
              list_style:none;
              }
            </style>
          </head>
          <body>
            <div id="content"></div>
            <script>
              const contentDiv = document.getElementById('content');
              contentDiv.innerHTML = '${widget.docsEn.replaceAll('\n\r', '')}';
            </script>
          </body>
        </html>
      """;
            final uri = Uri.dataFromString(htmlContent,
                mimeType: 'text/html', encoding: utf8);
            _controller?.loadUrl(uri.toString());
          },
          onPageFinished: (url) {
            _controller?.getHeight().then((double height) {
              setState(() {
                _height = height;
              });
            });
          },
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          gestureNavigationEnabled: true,
          onWebResourceError: (error) {
            print('Error loading page: $error');
          },
        )

    );
  }
}

class DoctorsAm extends StatefulWidget {
  String docsAm;
   DoctorsAm({super.key, required this.docsAm});

  @override
  State<DoctorsAm> createState() => _DoctorsAmState();
}

class _DoctorsAmState extends State<DoctorsAm> {
  WebViewPlusController? _controller;
  double _height = 1;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.maxFinite,
        height: _height,
        child: WebViewPlus(
          serverPort: 5353,
          javascriptChannels: null,
          onWebViewCreated: (controller) {
            _controller = controller;
            final htmlContent = """
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
              p {
               color: #999999;
                font-weight: 400;
      line-height: 24px;
              }
              body{
              background-color: white;
                font-family: Poppins, sans-serif;
              }
              li {
              list_style:none;
              }
            </style>
          </head>
          <body>
            <div id="content"></div>
            <script>
              const contentDiv = document.getElementById('content');
              contentDiv.innerHTML = '${widget.docsAm.replaceAll('\n\r', '')}';
            </script>
          </body>
        </html>
      """;
            final uri = Uri.dataFromString(htmlContent,
                mimeType: 'text/html', encoding: utf8);
            _controller?.loadUrl(uri.toString());
          },
          onPageFinished: (url) {
            _controller?.getHeight().then((double height) {
              setState(() {
                _height = height;
              });
            });
          },
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          gestureNavigationEnabled: true,
          onWebResourceError: (error) {
            print('Error loading page: $error');
          },
        )

    );
  }
}

