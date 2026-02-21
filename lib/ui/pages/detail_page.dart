import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/restaurant_model.dart';
import '../../data/models/result_state.dart';
import '../../providers/restaurant_provider.dart';
import '../../providers/favorite_provider.dart';
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
        context.read<FavoriteProvider>().checkFavorite(widget.restaurant.id);
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
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * 0.65;

    return Scaffold(
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, state, _) {
          final result = state.state;

          if (result is Loading) {
            return _buildLoadingState(imageHeight);
          } else if (result is HasData) {
            final detail =
                (result as HasData<RestaurantDetailResponse>).data.restaurant;
            return _buildDetailContent(context, detail, imageHeight);
          } else if (result is ErrorState) {
            return _buildErrorState(
              context,
              (result as ErrorState).message,
              imageHeight,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildLoadingState(double imageHeight) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildImageHeader(imageHeight),
          const SizedBox(height: 60),
          const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String message,
    double imageHeight,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildImageHeader(imageHeight),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(message, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  Widget _buildImageHeader(double imageHeight) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Hero(
          tag: widget.restaurant.pictureId,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
            child: Image.network(
              "https://restaurant-api.dicoding.dev/images/medium/${widget.restaurant.pictureId}",
              height: imageHeight,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.black.withValues(alpha: 0.5),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailContent(
    BuildContext context,
    RestaurantDetail detail,
    double imageHeight,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  _buildImageHeader(imageHeight),
                  const SizedBox(height: 28),
                ],
              ),
              Positioned(
                top: imageHeight - 28,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              detail.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontSize: 26),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Consumer<FavoriteProvider>(
                            builder: (context, favoriteProvider, _) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    favoriteProvider.isFavorite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: favoriteProvider.isFavorite
                                        ? Colors.redAccent
                                        : Colors.grey,
                                    size: 28,
                                  ),
                                  onPressed: () {
                                    if (favoriteProvider.isFavorite) {
                                      favoriteProvider.removeFavorite(
                                        widget.restaurant.id,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Removed from favorites'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    } else {
                                      favoriteProvider
                                          .addFavorite(widget.restaurant);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Added to favorites'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "${detail.address}, ${detail.city}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${detail.rating}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(indent: 24, endIndent: 24),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Description",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              detail.description,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(height: 1.5),
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Menu",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount:
                  detail.menus.foods.length + detail.menus.drinks.length,
              itemBuilder: (context, index) {
                final isFood = index < detail.menus.foods.length;
                final menu = isFood
                    ? detail.menus.foods[index]
                    : detail.menus.drinks[index - detail.menus.foods.length];
                final type = isFood ? 'food' : 'drink';
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SizedBox(
                    width: 150,
                    child: MenuCard(menu: menu, type: type),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Reviews",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 16),
          ...detail.customerReviews.take(3).map(
                (review) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Card(
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                review.date,
                                style: Theme.of(context).textTheme.bodySmall,
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
              ),
          if (detail.customerReviews.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 24.0,
              ),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    ReviewPage.routeName,
                    arguments: detail,
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Divider(height: 48),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Add Review",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              controller: _reviewController,
              decoration: const InputDecoration(
                labelText: 'Review',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
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
                            content: Text('Ulasan berhasil dikirim!'),
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
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
