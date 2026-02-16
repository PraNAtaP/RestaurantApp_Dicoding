import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/restaurant_model.dart';
import '../../data/models/result_state.dart';
import '../../providers/restaurant_provider.dart';
import '../widgets/menu_card.dart';
import 'review_page.dart';

class DetailPage extends StatefulWidget {
  static const routeName = '/detail_page';
  final Restaurant restaurant;

  const DetailPage({super.key, required this.restaurant});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<RestaurantDetailProvider>().fetchDetail(
          widget.restaurant.id,
        );
      }
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.5),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.restaurant.pictureId,
                child: Image.network(
                  "https://restaurant-api.dicoding.dev/images/medium/${widget.restaurant.pictureId}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer<RestaurantDetailProvider>(
              builder: (context, state, _) {
                final result = state.state;
                if (result is Loading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (result is HasData) {
                  final detail = (result as HasData<RestaurantDetailResponse>)
                      .data
                      .restaurant;
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detail.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "${detail.address}, ${detail.city}",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 24,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${detail.rating}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Description",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          detail.description,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(height: 1.5),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Foods",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.8,
                              ),
                          itemCount: detail.menus.foods.length,
                          itemBuilder: (context, index) => MenuCard(
                            menu: detail.menus.foods[index],
                            type: 'food',
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Drinks",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.8,
                              ),
                          itemCount: detail.menus.drinks.length,
                          itemBuilder: (context, index) => MenuCard(
                            menu: detail.menus.drinks[index],
                            type: 'drink',
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          "Reviews",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        ...detail.customerReviews
                            .take(3)
                            .map(
                              (review) => Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            review.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            review.date,
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        review.review,
                                        style: const TextStyle(height: 1.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        if (detail.customerReviews.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  ReviewPage.routeName,
                                  arguments: detail,
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('See All Reviews'),
                            ),
                          ),
                        const Divider(height: 48),
                        Text(
                          "Add Review",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _reviewController,
                          decoration: const InputDecoration(
                            labelText: 'Review',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.secondary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onSecondary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: () async {
                              if (_nameController.text.isNotEmpty &&
                                  _reviewController.text.isNotEmpty) {
                                try {
                                  await context
                                      .read<RestaurantDetailProvider>()
                                      .postReview(
                                        detail.id,
                                        _nameController.text,
                                        _reviewController.text,
                                      );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Ulasan berhasil dikirim!',
                                        ),
                                      ),
                                    );
                                  }
                                  _nameController.clear();
                                  _reviewController.clear();
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Gagal mengirim ulasan. Periksa koneksi internet Anda.',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            child: const Text('Submit Review'),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (result is ErrorState) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        (result as ErrorState).message,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
