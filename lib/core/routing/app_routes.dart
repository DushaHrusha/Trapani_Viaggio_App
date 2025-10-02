// app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/apartment.dart';
import '../../data/models/excursion_model.dart';
import '../../data/repositories/cars_repository.dart';
import '../../data/repositories/motorcycle_repository.dart';
import '../../data/repositories/vespa_repository.dart';
import '../../presentation/apartment_detail_screen.dart';
import '../../presentation/apartments_list_screen.dart';
import '../../presentation/bookmarks.dart';
import '../../presentation/chat_screen.dart';
import '../../presentation/circular_menu_screen.dart';
import '../../presentation/excursion_detail_screen.dart';
import '../../presentation/excursions_list.dart';
import '../../presentation/main_menu_screen.dart';
import '../../presentation/profile_screen.dart';
import '../../presentation/sign_up_screen.dart';
import '../../presentation/splash_screen.dart';
import '../../presentation/vehicle_details_screen.dart';

class AppRouter {
  static const String root = '/';
  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String signUp = '/auth/sign-up';

  // Main app routes
  static const String home = '/home';
  static const String menu = '/home/main-menu';

  // Feature routes
  static const String apartments = '/home/main-menu/apartments-list';
  static const String apartmentDetail = '/home/apartments/:id';

  static const String vehicleDetailsCars =
      '/home/main-menu/vehicle-details-cars';
  static const String vehicleDetailsMotorcycles =
      '/home/main-menu/vehicle-details-motorcycles';
  static const String vehicleDetailsVespa =
      '/home/main-menu/vehicle-details-vespa';

  static const String vehiclesByType = '/home/vehicles/:type';
  static const String vehicleDetail = '/home/vehicles/:type/:id';

  static const String excursions = '/home/main-menu/excursions-list';
  static const String excursionDetail = '/home/excursions/:id';

  // Profile routes
  static const String profile = '/profile';
  static const String bookmarks = '/profile/bookmarks';
  static const String chat = '/profile/chat';
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainMenuScreen(),
        routes: [
          GoRoute(
            path: 'main-menu',
            builder: (context, state) => const CircularMenuScreen(),
            routes: [
              // Apartments List
              GoRoute(
                path: 'apartments-list',
                builder: (context, state) => ApartmentsListScreen(),
                routes: [
                  // Apartment Detail
                  GoRoute(
                    path: 'apartment-detail',
                    builder: (context, state) {
                      final apartment = state.extra as Apartment;
                      return ApartmentDetailScreen(apartment: apartment);
                    },
                  ),
                ],
              ),

              GoRoute(
                path: 'vehicle-details-cars',
                builder: (context, state) => VehicleDetailsScreen(
                  vehicleRepository: CarsRepository(),
                  label: "automobiles",
                ),
              ),
              GoRoute(
                path: 'vehicle-details-motorcycles',
                builder: (context, state) => VehicleDetailsScreen(
                  vehicleRepository: MotorcycleRepository(),
                  label: "motorcycles",
                ),
              ),
              GoRoute(
                path: 'vehicle-details-vespa',
                builder: (context, state) => VehicleDetailsScreen(
                  vehicleRepository: VespaRepository(),
                  label: "vespa bikes",
                ),
              ),
              GoRoute(
                path: 'excursions-list',
                builder: (context, state) => ExcursionsList(),
                routes: [
                  GoRoute(
                    path: 'excursion-detail',
                    builder: (context, state) {
                      final excursion = state.extra as Excursion;
                      return ExcursionDetailScreen(excursion: excursion);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/bookmarks',
        builder: (context, state) => BookmarksScreen(),
      ),
      GoRoute(path: '/profile', builder: (context, state) => ProfileScreen()),
      GoRoute(path: '/chat', builder: (context, state) => ChatScreen()),
    ],

    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Ошибка')),
      body: const Center(child: Text('Не удалось загрузить страницу')),
    ),
  );

  static List<String> getAllRoutes() {
    return [
      '/home/main-menu/apartments-list',
      '/home/main-menu/vehicle-details-cars',
      '/home/main-menu/vehicle-details-motorcycles',
      '/home/main-menu/vehicle-details-motorcycles',
      '/home/main-menu/vehicle-details-vespa',
      '/home/main-menu/excursions-list',
    ];
  }
}
