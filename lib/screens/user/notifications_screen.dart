import 'package:flutter/material.dart';
import '../../widgets/notifications/notification_list_item.dart';
import '../../widgets/notifications/notifications_bottom_dock.dart';
import '../../widgets/notifications/notifications_day_separator.dart';
import '../../widgets/notifications/notifications_header.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              NotificationsHeader(onBack: () => Navigator.pop(context)),
              const SizedBox(height: 18),
              Expanded(
                child: ListView(
                  children: const [
                    NotificationListItem(
                      title: 'Lorem Ipsum is simply dummy text',
                      routeText: 'Kolkata · Digha',
                      time: '50Min Ago',
                    ),
                    SizedBox(height: 12),
                    NotificationListItem(
                      title: 'Lorem Ipsum is simply dummy text',
                      routeText: 'Kolkata · Digha',
                      time: '50Min Ago',
                    ),
                    SizedBox(height: 12),
                    NotificationListItem(
                      title: 'Lorem Ipsum is simply dummy text',
                      routeText: 'Kolkata · Digha',
                      time: '50Min Ago',
                    ),
                    SizedBox(height: 12),
                    NotificationListItem(
                      title: 'Lorem Ipsum is simply dummy text',
                      routeText: 'Kolkata · Digha',
                      time: '50Min Ago',
                    ),
                    SizedBox(height: 12),
                    NotificationListItem(
                      title: 'Lorem Ipsum is simply dummy text',
                      routeText: 'Kolkata · Digha',
                      time: '50Min Ago',
                    ),
                    SizedBox(height: 22),
                    NotificationsDaySeparator(label: 'Yesterday'),
                    SizedBox(height: 22),
                    NotificationListItem(
                      title: 'Lorem Ipsum is simply dummy text',
                      routeText: 'Kolkata · Digha',
                    ),
                    SizedBox(height: 12),
                    NotificationListItem(
                      title: 'Lorem Ipsum is simply dummy text',
                      routeText: 'Kolkata · Digha',
                    ),
                    SizedBox(height: 12),
                    NotificationListItem(
                      title: 'Lorem Ipsum is simply dummy text',
                      routeText: 'Kolkata · Digha',
                    ),
                    SizedBox(height: 12),
                    NotificationListItem(
                      title: 'Lorem Ipsum is simply dummy text',
                      routeText: 'Kolkata · Digha',
                    ),
                    SizedBox(height: 12),
                    NotificationListItem(
                      title: 'Lorem Ipsum is simply dummy text',
                      routeText: 'Kolkata · Digha',
                    ),
                    SizedBox(height: 18),
                  ],
                ),
              ),
              const NotificationsBottomDock(),
            ],
          ),
        ),
      ),
    );
  }
}
