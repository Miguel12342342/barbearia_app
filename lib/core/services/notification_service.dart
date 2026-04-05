import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter_timezone/flutter_timezone.dart';
import '../../features/scheduling/domain/entities/appointment.dart';
import '../router/app_router.dart';

@pragma('vm:entry-point')
Future<void> _fcmBackgroundHandler(RemoteMessage message) async {}

class NotificationService {
  final FirebaseFirestore _firestore;
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'appointments_channel';
  static const _channelName = 'Agendamentos';
  static const _channelDescription = 'Lembretes de agendamento';

  NotificationService(this._firestore);

  Future<void> init() async {
    tz_data.initializeTimeZones();
    final tzInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzInfo.identifier));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _local.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        appRouter.go('/booking');
      },
    );

    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDescription,
            importance: Importance.max,
          ),
        );

    FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp
        .listen((_) => appRouter.go('/booking'));

    final initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => appRouter.go('/booking'));
    }

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification == null) return;
      _local.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );
    });
  }

  Future<void> saveToken(String userId) async {
    if (userId.isEmpty) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      await _firestore
          .collection('users')
          .doc(userId)
          .set({'fcmToken': token}, SetOptions(merge: true));
    } catch (e) {
      log('NotificationService.saveToken: $e');
    }
  }

  Future<void> scheduleAppointmentReminder(Appointment appointment) async {
    final date =
        appointment.date.value.fold((_) => null, (d) => d as DateTime?);
    if (date == null) return;
    final reminderTime = date.subtract(const Duration(hours: 24));
    if (!reminderTime.isAfter(DateTime.now())) return;
    try {
      final tzDate = tz.TZDateTime.from(reminderTime, tz.local);
      final h = date.hour.toString().padLeft(2, '0');
      final m = date.minute.toString().padLeft(2, '0');
      await _local.zonedSchedule(
        appointment.id.hashCode.abs(),
        'Lembrete de agendamento',
        'Você tem ${appointment.serviceName} amanhã às $h:$m',
        tzDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: appointment.id,
      );
    } catch (e) {
      log('NotificationService.scheduleReminder: $e');
    }
  }

  Future<void> cancelReminder(String appointmentId) async {
    await _local.cancel(appointmentId.hashCode.abs());
  }
}
