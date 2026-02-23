import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/result_state.dart';
import '../../providers/restaurant_provider.dart';
import '../widgets/card_restaurant.dart';
import '../widgets/state_info_widget.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/search_page';

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Restaurant...',
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor:
                    Theme.of(context).cardTheme.color ??
                    Theme.of(context).colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              onChanged: (query) {
                Provider.of<RestaurantSearchProvider>(
                  context,
                  listen: false,
                ).searchRestaurant(query);
              },
            ),
          ),
          Expanded(
            child: Consumer<RestaurantSearchProvider>(
              builder: (context, state, _) {
                if (state.state is Loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.state is HasData) {
                  final data = (state.state as HasData).data;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    itemCount: data.restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = data.restaurants[index];
                      return CardRestaurant(restaurant: restaurant);
                    },
                  );
                } else if (state.state is NoData) {
                  return StateInfoWidget.empty(
                    message: (state.state as NoData).message,
                  );
                } else if (state.state is ErrorState) {
                  final errorMessage = (state.state as ErrorState).message;
                  return StateInfoWidget.error(message: errorMessage);
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 80,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Find your favorite restaurant',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
