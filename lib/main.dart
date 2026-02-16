import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/api/api_service.dart';
import 'data/models/restaurant_model.dart';
import 'providers/restaurant_provider.dart';
import 'styles/styles.dart';
import 'ui/pages/detail_page.dart';
import 'ui/pages/home_page.dart';
import 'ui/pages/search_page.dart';
import 'ui/pages/review_page.dart';

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

        ChangeNotifierProvider(
          create: (_) => RestaurantDetailProvider(apiService: ApiService()),
        ),
      ],
      child: MaterialApp(
        title: 'Restaurant App',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          DetailPage.routeName: (context) => DetailPage(
            restaurant:
                ModalRoute.of(context)?.settings.arguments as Restaurant,
          ),
          SearchPage.routeName: (context) => const SearchPage(),
          ReviewPage.routeName: (context) => ReviewPage(
            restaurant:
                ModalRoute.of(context)?.settings.arguments as RestaurantDetail,
          ),
        },
      ),
    );
  }
}
