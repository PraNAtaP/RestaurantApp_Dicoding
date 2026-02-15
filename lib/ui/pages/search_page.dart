import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/result_state.dart';
import '../../providers/restaurant_provider.dart';
import '../widgets/card_restaurant.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/search_page';

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Restaurant...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16)
              ),
              onChanged: (query) {
                Provider.of<RestaurantSearchProvider>(context, listen: false)
                    .searchRestaurant(query);
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
                      var restaurant = data.restaurants[index];
                      return CardRestaurant(restaurant: restaurant);
                    },
                  );
                } else if (state.state is ErrorState) {
                   if (state.message.isEmpty) return Container();
                   return Center(child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                       const SizedBox(height: 16),
                       Text(state.message, style: const TextStyle(color: Colors.grey)),
                     ],
                   ));
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        const Text('Find your favorite restaurant', style: TextStyle(color: Colors.grey)),
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
