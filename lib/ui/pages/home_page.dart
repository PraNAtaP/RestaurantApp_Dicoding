import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/result_state.dart';
import '../../providers/restaurant_provider.dart';
import '../widgets/card_restaurant.dart';
import '../widgets/state_info_widget.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<RestaurantListProvider>().refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Restaurant',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Recommendation restaurant for you!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        toolbarHeight: 100,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 28),
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.routeName);
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
      body: Consumer<RestaurantListProvider>(
        builder: (context, state, _) {
          if (state.state is Loading || state.state is Initial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.state is HasData) {
            final data = (state.state as HasData).data;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: data.restaurants.length,
              itemBuilder: (context, index) {
                var restaurant = data.restaurants[index];
                return CardRestaurant(restaurant: restaurant);
              },
            );
          } else if (state.state is NoData) {
            return StateInfoWidget.empty(
              message: (state.state as NoData).message,
            );
          } else if (state.state is ErrorState) {
            final errorMessage = (state.state as ErrorState).message;
            return StateInfoWidget.error(
              message: errorMessage,
              onRetry: () {
                Provider.of<RestaurantListProvider>(
                  context,
                  listen: false,
                ).refresh();
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
