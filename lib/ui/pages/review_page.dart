import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/restaurant_model.dart';
import '../../data/models/result_state.dart';
import '../../providers/restaurant_provider.dart';

class ReviewPage extends StatelessWidget {
  static const routeName = '/review_page';
  final RestaurantDetail restaurant;

  const ReviewPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reviews: ${restaurant.name}')),
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, state, _) {
          final result = state.state;
          var reviews = restaurant.customerReviews;

          if (result is HasData) {
            final currentDetail =
                (result as HasData<RestaurantDetailResponse>).data.restaurant;
            if (currentDetail.id == restaurant.id) {
              reviews = currentDetail.customerReviews;
            }
          }

          if (reviews.isEmpty) {
            return const Center(child: Text('No reviews yet.'));
          }

          return ListView.builder(
            itemCount: reviews.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            review.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            review.date,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(review.review, style: const TextStyle(height: 1.5)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
