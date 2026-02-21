import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/models/restaurant_model.dart';
import 'package:restaurant_app/data/models/result_state.dart';
import 'package:restaurant_app/providers/restaurant_provider.dart';

import 'restaurant_provider_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late MockApiService mockApiService;
  late RestaurantListProvider provider;

  setUp(() {
    mockApiService = MockApiService();
  });

  group('RestaurantListProvider', () {
    test('initial state should be Initial before fetch completes', () {
      when(mockApiService.getRestaurantList()).thenAnswer(
        (_) async => Future.delayed(
          const Duration(seconds: 10),
          () => RestaurantListResponse(
            error: false,
            message: 'success',
            count: 0,
            restaurants: [],
          ),
        ),
      );

      provider = RestaurantListProvider(apiService: mockApiService);

      expect(provider.state, isA<Loading>());
    });

    test('should return HasData when API call is successful', () async {
      final mockResponse = RestaurantListResponse(
        error: false,
        message: 'success',
        count: 2,
        restaurants: [
          Restaurant(
            id: '1',
            name: 'Test Restaurant 1',
            description: 'Description 1',
            pictureId: 'pic1',
            city: 'Jakarta',
            rating: 4.5,
          ),
          Restaurant(
            id: '2',
            name: 'Test Restaurant 2',
            description: 'Description 2',
            pictureId: 'pic2',
            city: 'Bandung',
            rating: 4.0,
          ),
        ],
      );

      when(mockApiService.getRestaurantList()).thenAnswer(
        (_) async => mockResponse,
      );

      provider = RestaurantListProvider(apiService: mockApiService);

      await Future.delayed(const Duration(milliseconds: 500));

      expect(provider.state, isA<HasData<RestaurantListResponse>>());
      final data = (provider.state as HasData<RestaurantListResponse>).data;
      expect(data.restaurants.length, 2);
      expect(data.restaurants.first.name, 'Test Restaurant 1');
    });

    test('should return ErrorState when API throws SocketException', () async {
      when(mockApiService.getRestaurantList()).thenThrow(
        const SocketException('No Internet Connection'),
      );

      provider = RestaurantListProvider(apiService: mockApiService);

      await Future.delayed(const Duration(milliseconds: 500));

      expect(provider.state, isA<ErrorState>());
      final errorState = provider.state as ErrorState;
      expect(errorState.message, contains('No Internet Connection'));
    });

    test('should return ErrorState when API throws generic exception',
        () async {
      when(mockApiService.getRestaurantList()).thenThrow(
        Exception('Server Error'),
      );

      provider = RestaurantListProvider(apiService: mockApiService);

      await Future.delayed(const Duration(milliseconds: 500));

      expect(provider.state, isA<ErrorState>());
      final errorState = provider.state as ErrorState;
      expect(errorState.message, contains('No Internet Connection'));
    });
  });
}
