import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:restaurant_app/data/models/restaurant_model.dart';
import 'package:restaurant_app/providers/favorite_provider.dart';
import 'package:restaurant_app/ui/widgets/card_restaurant.dart';
import 'package:restaurant_app/data/db/database_helper.dart';

class MockDatabaseHelper extends Fake implements DatabaseHelper {
  final List<Restaurant> _favorites = [];

  @override
  Future<List<Restaurant>> getFavorites() async {
    return _favorites;
  }

  @override
  Future<bool> isFavorite(String id) async {
    return _favorites.any((r) => r.id == id);
  }

  @override
  Future<void> insertFavorite(Restaurant restaurant) async {
    _favorites.add(restaurant);
  }

  @override
  Future<void> removeFavorite(String id) async {
    _favorites.removeWhere((r) => r.id == id);
  }
}

void main() {
  group('CardRestaurant Widget Test', () {
    late Restaurant testRestaurant;
    late MockDatabaseHelper mockDb;

    setUp(() {
      mockDb = MockDatabaseHelper();
      testRestaurant = Restaurant(
        id: '1',
        name: 'Test Restaurant',
        description: 'Description 1',
        pictureId: 'pic1',
        city: 'Bandung',
        rating: 4.5,
      );
    });

    testWidgets('should display restaurant name, city, and rating properly', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ChangeNotifierProvider(
                create: (_) => FavoriteProvider(databaseHelper: mockDb),
                child: CardRestaurant(restaurant: testRestaurant),
              ),
            ),
          ),
        );

        expect(find.text('Test Restaurant'), findsOneWidget);
        expect(find.text('Bandung'), findsOneWidget);
        expect(find.text('4.5'), findsOneWidget);
        expect(find.byType(Image), findsOneWidget);
      });
    });

    testWidgets('should toggle favorite icon when tapped', (
      WidgetTester tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ChangeNotifierProvider(
                create: (_) => FavoriteProvider(databaseHelper: mockDb),
                child: CardRestaurant(restaurant: testRestaurant),
              ),
            ),
          ),
        );

        // Initially not favorited
        expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
        expect(find.byIcon(Icons.favorite_rounded), findsNothing);

        // Tap to favorite
        await tester.tap(find.byIcon(Icons.favorite_border_rounded));
        await tester.pumpAndSettle();

        // Should be favorited
        expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
        expect(find.byIcon(Icons.favorite_border_rounded), findsNothing);
      });
    });
  });
}
