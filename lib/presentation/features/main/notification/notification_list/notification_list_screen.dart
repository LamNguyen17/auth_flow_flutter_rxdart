import 'package:auth_flow_flutter_rxdart/presentation/components/app_bar.dart';
import 'package:flutter/material.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  NotificationListScreenState createState() => NotificationListScreenState();
}

class NotificationListScreenState extends State<NotificationListScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      type: AppbarType.normal,
      title: 'Notifications',
      child: Container(),
    );
  }
}
