// import 'package:dartz/dartz.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // /// Input
  // final Function0<void> dispose;
  // final Sink<NotificationResponse> notificationS;
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  //
  // NotificationService._({
  //   required this.dispose,
  //   required this.notificationS,
  // });
  //
  // factory NotificationService() {
  //   final notification = BehaviorSubject<NotificationResponse>();
  //
  //   return NotificationService._(
  //     notificationS: notification,
  //     dispose: () {
  //       notification.close();
  //     },
  //   );
  // }
  //
  // Future<void> init() async {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');
  //   const DarwinInitializationSettings initializationSettingsIOS =
  //       DarwinInitializationSettings(
  //     requestAlertPermission: true,
  //     requestBadgePermission: false,
  //     requestSoundPermission: false,
  //   );
  //   const InitializationSettings initializationSettings =
  //       InitializationSettings(
  //           android: initializationSettingsAndroid,
  //           iOS: initializationSettingsIOS);
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onDidReceiveNotificationResponse:
  //           (NotificationResponse notificationResponse) {
  //     notificationS.add(notificationResponse);
  //   });
  // }
  //
  // Future<void> showNotification(String? title, String? body) async {
  //   const androidNotificationDetail =
  //       AndroidNotificationDetails('0', 'general');
  //   const iosNotificatonDetail = DarwinNotificationDetails();
  //   const notificationDetails = NotificationDetails(
  //     iOS: iosNotificatonDetail,
  //     android: androidNotificationDetail,
  //   );
  //   await flutterLocalNotificationsPlugin.show(
  //       0, title, body, notificationDetails);
  // }
}
