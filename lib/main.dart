import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/api/api_service.dart';
import 'data/models/restaurant_model.dart';
import 'data/preferences/preference_helper.dart';
import 'providers/restaurant_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/settings_provider.dart';
import 'styles/styles.dart';
import 'ui/pages/detail_page.dart';
import 'ui/pages/main_navigation.dart';
import 'ui/pages/search_page.dart';
import 'ui/pages/review_page.dart';
import 'utils/notification_helper.dart';
import 'utils/background_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final preferenceHelper = PreferenceHelper(
    sharedPreferences: sharedPreferences,
  );

  try {
    await NotificationHelper.initNotifications();
  } catch (e) {
    debugPrint('Notification init failed: $e');
  }

  try {
    await BackgroundService.initializeWorkmanager();
  } catch (e) {
    debugPrint('Workmanager init failed: $e');
  }

  runApp(MyApp(preferenceHelper: preferenceHelper));
}

class MyApp extends StatelessWidget {
  final PreferenceHelper preferenceHelper;

  const MyApp({super.key, required this.preferenceHelper});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantListProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => RestaurantSearchProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (_) => RestaurantDetailProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(preferenceHelper: preferenceHelper),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          return MaterialApp(
            title: 'Restaurant App',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: settingsProvider.themeMode,
            initialRoute: MainNavigation.routeName,
            routes: {
              MainNavigation.routeName: (context) => const MainNavigation(),
              DetailPage.routeName: (context) => DetailPage(
                restaurant: ModalRoute.of(context)?.settings.arguments
                    as Restaurant,
              ),
              SearchPage.routeName: (context) => const SearchPage(),
              ReviewPage.routeName: (context) => ReviewPage(
                restaurant: ModalRoute.of(context)?.settings.arguments
                    as RestaurantDetail,
              ),
            },
          );
        },
      ),
    );
  }
}
