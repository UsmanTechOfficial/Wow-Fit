import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:wowfit/Utils/showtoaist.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    // Android initialization

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // ios initialization
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    // the initialization settings are initialized after they are setted
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    _configureLocalTimeZone();
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> showNotification(int id, String title, String body, int hours,
      int minutes, DateTime dateTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _convertTime(hours, minutes, dateTime),
      const NotificationDetails(
        // Android details
        android: AndroidNotificationDetails('main_channel', 'Main Channel',
            channelDescription: "WowFit",
            importance: Importance.max,
            priority: Priority.max),
        // iOS details
        iOS: DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ), // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle:
          true, // To show notification even when the app is closed
    );
  }

  Future<void> showSimpleNotification(int id, String title, String body) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        // Android details
        android: AndroidNotificationDetails('main_channel', 'Main Channel',
            channelDescription: "WowFit",
            importance: Importance.max,
            priority: Priority.max),
        // iOS details
        iOS: DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  tz.TZDateTime _convertTime(int hour, int minutes, DateTime dateTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    Duration duration = dateTime.difference(now);
    tz.TZDateTime scheduleDate = now;
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(Duration(hours: hour, minutes: minutes));
    } else {
      scheduleDate = now.add(duration);
    }
    return scheduleDate;
  }

  Future<void> setNotification(String startTime, int index, String workoutName,
      int notify, DateTime dateTime) async {
    int time = _notify(notify);

    var format = DateFormat("HH:mm");
    var start = format.parse(startTime);
    // subtract 10 minutes from start time
    var checktime = DateFormat("HH:mm").format(start.subtract(
        Duration(hours: time != 30 ? time : 0, minutes: time == 30 ? 30 : 00)));
    List<String> list = checktime.split(':');
    final dateadded = dateTime
        .add(Duration(hours: int.parse(list[0]), minutes: int.parse(list[1])));

      if(dateadded.isAfter(DateTime.now())){
        showNotification(
            index,
            '$workoutName ${'at'.tr} $startTime',
            '${'Workout will start in'.tr} $time ${time != 30 ? 'hours'.tr : 'minutes'.tr}',
            int.parse(list[0]),
            int.parse(list[1]),
            dateadded);
      }else{
        showToast('Notification cant be sent\nPlease choose a time in the future to send notification',length: Toast.LENGTH_LONG);
      }
  }

  int _notify(int notify) {
    switch (notify) {
      case 0:
        return 0;
      case 1:
        return 30;
      case 2:
        return 1;
      case 3:
        return 12;
      default:
        return 0;
    }
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(DateTime.now().timeZoneName));
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<dynamic> selectNotification(String? payload) async {}
}
