import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/services/api_service.dart';
import 'data/repositories/auth_repository.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/room/screens/room_info_screen.dart';
import 'features/room/screens/room_registration_screen.dart';
import 'features/billing/screens/bills_screen.dart';
import 'features/issues/screens/issues_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/notification/screens/notification_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/room/providers/room_provider.dart';
import 'data/repositories/room_repository.dart';
import 'features/registration/providers/registration_provider.dart';
import 'features/return/providers/return_provider.dart';
import 'data/repositories/registration_repository.dart';
import 'data/repositories/return_repository.dart';
import 'data/repositories/area_repository.dart';
import 'features/room/providers/area_provider.dart';
import 'data/repositories/bill_repository.dart';
import 'features/billing/providers/bill_provider.dart';
// Import các screen và provider khác

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  // await Firebase.initializeApp();

  // Khởi tạo SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => ApiService(prefs),
        ),
        ProxyProvider<ApiService, AuthRepository>(
          update: (_, apiService, __) => AuthRepository(apiService, prefs),
        ),
        ChangeNotifierProxyProvider<AuthRepository, AuthProvider>(
          create: (context) => AuthProvider(
            context.read<AuthRepository>(),
          ),
          update: (_, authRepository, previous) => previous!,
        ),
        Provider(
          create: (context) => RoomRepository(
            context.read<ApiService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RoomProvider(
            context.read<RoomRepository>(),
          ),
        ),
        Provider(
          create: (context) => RegistrationRepository(
            context.read<ApiService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RegistrationProvider(
            context.read<RegistrationRepository>(),
          ),
        ),
        Provider(
          create: (context) => ReturnRepository(
            context.read<ApiService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ReturnProvider(
            context.read<ReturnRepository>(),
          ),
        ),
        Provider(
          create: (context) => AreaRepository(
            context.read<ApiService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AreaProvider(
            context.read<AreaRepository>(),
          ),
        ),
        Provider(
          create: (context) => BillRepository(
            context.read<ApiService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => BillProvider(
            context.read<BillRepository>(),
          ),
        ),
        // Thêm các provider khác
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'KTX App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // Customize theme
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              );
            case '/home':
              return MaterialPageRoute(
                builder: (_) => const HomeScreen(),
              );
            case '/room-info':
              return MaterialPageRoute(
                builder: (_) => const RoomInfoScreen(),
              );
            case '/room-registration':
              return MaterialPageRoute(
                builder: (_) => const RoomRegistrationScreen(),
              );
            case '/bills':
              return MaterialPageRoute(
                builder: (_) => const BillsScreen(),
              );
            case '/issues':
              return MaterialPageRoute(
                builder: (_) => const IssuesScreen(),
              );
            case '/profile':
              return MaterialPageRoute(
                builder: (_) => const ProfileScreen(),
              );
            case '/notifications':
              return MaterialPageRoute(
                builder: (_) => const NotificationScreen(),
              );
            case '/settings':
              return MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              );
            default:
              return MaterialPageRoute(
                builder: (_) => const LoginScreen(),
              );
          }
        },
      ),
    );
  }
}
