import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../data/models/restaurant_model.dart';
import '../../data/models/result_state.dart';
import '../../providers/restaurant_provider.dart';
import '../widgets/menu_card.dart';

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
      Provider.of<RestaurantDetailProvider>(context, listen: false)
          .fetchDetail(widget.restaurant.id);
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
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.restaurant.pictureId,
                child: Image.network(
                  "https://restaurant-api.dicoding.dev/images/medium/${widget.restaurant.pictureId}",
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, stack) =>
                      const Center(child: Icon(Icons.error)),
                ),
              ),
              title: null,
              titlePadding: const EdgeInsets.only(left: 16, bottom: 20),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          SliverToBoxAdapter(
            child: Container(
              transform: Matrix4.translationValues(0, 0, 0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(27.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.restaurant.name,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.redAccent, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.restaurant.city,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const Icon(Icons.star_rounded,
                            color: Colors.amber, size: 24),
                        const SizedBox(width: 4),
                        Text(
                          "${widget.restaurant.rating}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Description",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.restaurant.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5, color: Colors.grey[700]),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24),
                    Consumer<RestaurantDetailProvider>(
                      builder: (context, state, _) {
                        if (state.state is Loading) {
                          return Center(
                              child: Lottie.network(
                                  'https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json',
                                  height: 150,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const CircularProgressIndicator()));


// ... (inside the build method, specifically Consumer builder)
                        } else if (state.state is HasData) {
                          final detail = (state.state as HasData).data.restaurant;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Foods",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.8, // Adjust for card height
                                ),
                                itemCount: detail.menus.foods.length,
                                itemBuilder: (context, index) {
                                  return MenuCard(
                                    menu: detail.menus.foods[index],
                                    type: 'food',
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              Text("Drinks",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.8,
                                ),
                                itemCount: detail.menus.drinks.length,
                                itemBuilder: (context, index) {
                                   return MenuCard(
                                    menu: detail.menus.drinks[index],
                                    type: 'drink',
                                  );
                                },
                              ),
                              const SizedBox(height: 32),
                              Text("Reviews",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: detail.customerReviews.length,
                                itemBuilder: (context, index) {
                                  final review = detail.customerReviews[index];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 12), // Improved spacing
                                    elevation: 0,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        side: BorderSide(
                                            color: Colors.grey[200]!)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0), // More padding
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(review.name,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(review.date,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey)),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(review.review,
                                              style: TextStyle(
                                                  color: Colors.grey[800], height: 1.5)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        } else if (state.state is ErrorState) {
                          return Center(child: Text(state.message));
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    const Divider(height: 32),
                     Text("Add Review",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                     Container(
                       padding: const EdgeInsets.all(16),
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(12),
                         border: Border.all(color: Colors.grey[200]!)
                       ),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.stretch,
                         children: [
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _reviewController,
                              decoration: const InputDecoration(
                                labelText: 'Review',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(vertical: 12)
                              ),
                              onPressed: () {
                                if (_nameController.text.isNotEmpty &&
                                    _reviewController.text.isNotEmpty) {
                                  Provider.of<RestaurantDetailProvider>(
                                          context,
                                          listen: false)
                                      .postReview(widget.restaurant.id,
                                          _nameController.text,
                                          _reviewController.text);
                                  _reviewController.clear();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Review Posted')));
                                }
                              },
                              child: const Text('Submit Review'),
                            )
                         ],
                       ),
                     )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
