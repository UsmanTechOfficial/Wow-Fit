import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:wowfit/Utils/showtoaist.dart';

class CheckInternet {
  var InternetStatus = "Unknown";
  var contentmessage = "Unknown";
  static bool internetStatus = false;

/*  void _showDialog(String content, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text('Internet'),
              content: new Text(content),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("Close"))
              ]);
        });
  }*/

  final StreamSubscription<InternetConnectionStatus> listener =
      InternetConnectionChecker().onStatusChange.listen(
    (InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          internetStatus = true;
          // ignore: avoid_print
          print('Data connection is available.');
          showToast('Internet Connected');
          break;
        case InternetConnectionStatus.disconnected:
          // ignore: avoid_print
          print('You are disconnected from the internet.');
          showToast('Internet Not connected');
          internetStatus = false;
          break;
      }
    },
  );

  // close listener after 30 seconds, so the program doesn't run forever
  // await Future<void>.delayed(const Duration(seconds: 30));
  // await listener.cancel();

}
