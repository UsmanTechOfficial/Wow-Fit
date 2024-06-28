import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Utils/color_resources.dart';
import '../main.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Support'.tr,
        ),
        backgroundColor: ColorResources.COLOR_BLUE,
      ),
      // body: SafeArea(
      //   child: SizedBox(
      //     child: WebView(
      //       initialUrl: Uri.dataFromString('''
      // <link rel="stylesheet" href="style.css">
      // <div id="chatra-wrapper" style="width: 100%; height: 100%;"></div>
      //
      // <script>
      // if(!document.__defineGetter__) {
      //   Object.defineProperty(document, 'cookie', {
      //       get: function(){return ''},
      //       set: function(){return true},
      //   });
      //   } else {
      //       document.__defineGetter__("cookie", function() { return '';} );
      //       document.__defineSetter__("cookie", function() {} );
      //   }
      //   window.ChatraSetup = {
      //     mode: 'frame',
      //     injectTo: 'chatra-wrapper',
      //     clientId: $supportID,
      //   }
      // </script>
      //
      // <script>
      // (function(d, w, c) {
      // w.ChatraID = 'BdQY73SbdoqQsg9Lu';
      // var s = d.createElement('script');
      // w[c] = w[c] || function() {
      // (w[c].q = w[c].q || []).push(arguments);
      // };
      // s.async = true;
      // s.src = 'https://call.chatra.io/chatra.js';
      // if (d.head) d.head.appendChild(s);
      // })(document, window, 'Chatra');
      // </script>
      // ''', mimeType: 'text/html').toString(),
      //       javascriptMode: JavascriptMode.unrestricted,
      //       zoomEnabled: false,
      //     ),
      //   ),
      // ),
    );
  }
}