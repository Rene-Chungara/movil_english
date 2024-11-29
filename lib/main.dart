import 'package:flutter/material.dart';
import 'views/home_view.dart';
import 'views/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';
// Si vas a usar Gemini, asegúrate de inicializarlo
// import 'package:flutter_gemini/flutter_gemini.dart';

// Configuración de notificaciones locales
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Manejo de mensajes en segundo plano
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Mensaje recibido en segundo plano: ${message.messageId}");
}

FirebaseAnalytics analytics = FirebaseAnalytics.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("Inicializando Firebase...");
  try {
    await Firebase.initializeApp();
    print("Firebase inicializado correctamente.");

    // Configuración para manejar mensajes en segundo plano
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Configuración inicial de notificaciones locales
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("Notificación seleccionada: ${response.payload}");
        // Aquí puedes manejar la acción según el payload de la notificación
      },
    );

    // Obtener y mostrar el token FCM para pruebas
    String? token = await FirebaseMessaging.instance.getToken();
    print("Token de registro FCM: $token");

    // Inicializar el manejador de notificaciones
    NotificationHandler.initialize();

    // Si necesitas usar Gemini:
    // Gemini.init(apiKey: 'api_key_edberto');

    runApp(const MyApp());
  } catch (e) {
    print("Error durante la inicialización de Firebase: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("Construyendo MyApp...");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()), // Provider para autenticación
      ],
      child: MaterialApp(
        title: 'Learning English',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics), // Analytics observer
        ],
        home: LoginScreen(), // Pantalla inicial
      ),
    );
  }
}

class NotificationHandler {
  // Inicializa los listeners para las notificaciones
  static void initialize() {
    // Manejar notificaciones en primer plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensaje recibido en primer plano: ${message.notification?.title}');
      _showNotification(
        message.notification?.title ?? 'Sin título',
        message.notification?.body ?? 'Sin contenido',
      );
    });

    // Manejar notificaciones cuando el usuario toca una notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Mensaje recibido al abrir la app: ${message.notification?.title}');
      // Aquí puedes manejar la navegación según el payload
    });
  }

  // Muestra notificaciones locales
  static Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'high_importance_channel', // ID del canal
      'Notificaciones importantes', // Nombre del canal
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // ID de la notificación
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
