import 'dart:io';

import 'package:ders_rotam/public/constants.dart';
import 'package:ders_rotam/public/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as htt;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as wss;
import 'package:flutter_native_html_to_pdf/flutter_native_html_to_pdf.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  InAppWebViewController? controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (controller != null) {
              if (await controller!.canGoBack()) {
                controller!.goBack();
              }
            }
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                controller?.loadUrl(
                    urlRequest: URLRequest(url: WebUri(Constants.url)));
              },
              icon: const Icon(Icons.home)),
          IconButton(
              onPressed: () {
                shareAction();
              },
              icon: const Icon(Icons.share)),
        ],
        title: const Text(
          Strings.appName,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: InAppWebView(
        onWebViewCreated: (c) {
          controller = c;
        },
        onLoadStart: (controller, url) {
          EasyLoading.show();
        },
        onLoadStop: (controller, url) {
          EasyLoading.dismiss();
        },
        initialUrlRequest: URLRequest(
          url: WebUri(Constants.url),
        ),
        initialSettings: InAppWebViewSettings(
            safeBrowsingEnabled: false,),
      ),
    );
  }

  Future<void> printAction() async {
    var image = await controller?.takeScreenshot();

    var path = await getApplicationSupportDirectory();
    String uuid = const Uuid().v1();
    String pathString = '${path.path}$uuid.png';

    File file = File(pathString);

    file.create();
    file.writeAsBytes(image!);

    Share.shareXFiles([XFile(file.path)]);
  }

  Future<void> shareAction() async {
    String? html;
    try {
      html = await controller!.getHtml();
    } catch (e) {
      print(e.toString());
    }
    if (html != null) {
      String uuid = const Uuid().v1();
      var path = await getApplicationSupportDirectory();

      final flutterNativeHtmlToPdfPlugin = FlutterNativeHtmlToPdf();

      final generatedPdfFile =
          await flutterNativeHtmlToPdfPlugin.convertHtmlToPdf(
        html: html,
        targetDirectory: path.path,
        targetName: uuid,
      );

      Share.shareXFiles([XFile(generatedPdfFile!.path)]);
    }
  }
}
