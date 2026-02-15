
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/api/api_service.dart';
import 'data/models/restaurant_model.dart';
import 'providers/restaurant_provider.dart';
import 'styles/styles.dart';
import 'ui/pages/detail_page.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
         // Details provider usually created at page level or here if we want cache.
         // But for simplicity/best practice of scoped access, let's keep it here or instantiate in DetailPage.
         // However, providing it here is easier for access across the app if needed, 
         // but Detail usually needs an ID to fetch.
         // Better to use ChangeNotifierProvider with a "child" or in the route.
         // For the prompt requirement "main.dart (beserta konfigurasi Theme)", 
         // we will just register the common ones. Detail might be instantiated in the route or page.
         // Actually, let's define it here blank/lazy or handle inside DetailPage.
         ChangeNotifierProvider(
             create: (_) => RestaurantDetailProvider(apiService: ApiService())
         )
      ],
      child: MaterialApp(
        title: 'Restaurant App',
        theme: lightTheme,
        darkTheme: darkTheme, // ThemeMode.system is default
        themeMode: ThemeMode.system, 
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          DetailPage.routeName: (context) => DetailPage(
                restaurant: ModalRoute.of(context)?.settings.arguments as Restaurant,
              ),
          SearchPage.routeName: (context) => const SearchPage(),
        },
      ),
    );
  }
}
