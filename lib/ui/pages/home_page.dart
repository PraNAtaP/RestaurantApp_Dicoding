import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/result_state.dart';
import '../../providers/restaurant_provider.dart';
import '../widgets/card_restaurant.dart';
import 'search_page.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home_page';

  const HomePage({super.key});

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
          if (state.state is Loading) {
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
          } else if (state.state is ErrorState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Provider.of<RestaurantListProvider>(
                          context,
                          listen: false,
                        ).refresh();
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text(''));
          }
        },
      ),
    );
  }
}
