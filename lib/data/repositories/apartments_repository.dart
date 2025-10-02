import 'package:flutter/material.dart';
import '../models/apartment.dart';

class ApartmentsRepository {
  List<Apartment> apartments = [
    Apartment(
      id: 3,
      title: 'Orizzonte Mare Beachside Suites',
      imageUrl: [
        "assets/images/0fc1bbc7df91a6e25b490e517f368e930f0b76ec.jpg",
        "assets/images/0fc1bbc7df91a6e25b490e517f368e930f0b76ec.jpg",
        "assets/images/0fc1bbc7df91a6e25b490e517f368e930f0b76ec.jpg",
        "assets/images/0fc1bbc7df91a6e25b490e517f368e930f0b76ec.jpg",
        "assets/images/0fc1bbc7df91a6e25b490e517f368e930f0b76ec.jpg",
      ],
      description:
          'Close to the sea apartment complex. Broadly speaking, a hotel is a managed building or establishment, which provides guests with a place to stay overnight – on a short-term basis',
      price: 99,
      iconServices: [
        Icons.wifi,
        Icons.ac_unit,
        Icons.pool,
        Icons.local_parking,
        Icons.restaurant,
        Icons.fitness_center,
        Icons.local_parking,
        Icons.ac_unit,
      ],
      rating: 8.6,
      numberReviews: 121,
      address: "Via Pantalica, 26, 91100, Trapani, Italy.",
    ),
    Apartment(
      id: 4,
      title: 'Central Gallery Palazzo Rooms',
      imageUrl: [
        "assets/images/b84b34d8d475bdf768225b95d9e430f918466838.jpg",
        "assets/images/b84b34d8d475bdf768225b95d9e430f918466838.jpg",
        "assets/images/b84b34d8d475bdf768225b95d9e430f918466838.jpg",
        "assets/images/b84b34d8d475bdf768225b95d9e430f918466838.jpg",
        "assets/images/b84b34d8d475bdf768225b95d9e430f918466838.jpg",
      ],
      description: 'Restored historic building from the 1800s',
      price: 79,
      iconServices: [
        Icons.wifi,
        Icons.fireplace,
        Icons.hot_tub,
        Icons.local_parking,
        Icons.kitchen,
        Icons.snowboarding,
        Icons.ac_unit,
      ],
      rating: 9.2,
      numberReviews: 178,
      address: "Zermatt, Switzerland",
    ),
    Apartment(
      id: 5,
      title: 'Apartamenti Sant’ Andrea',
      imageUrl: [
        "assets/images/980715515f5fb5e37478585f7979f1d1ae7b0608.jpg",
        "assets/images/980715515f5fb5e37478585f7979f1d1ae7b0608.jpg",
        "assets/images/980715515f5fb5e37478585f7979f1d1ae7b0608.jpg",
        "assets/images/980715515f5fb5e37478585f7979f1d1ae7b0608.jpg",
        "assets/images/980715515f5fb5e37478585f7979f1d1ae7b0608.jpg",
      ],
      description: 'Close to the sea apartment complex',
      price: 109,
      iconServices: [
        Icons.wifi,
        Icons.fireplace,
        Icons.hot_tub,
        Icons.local_parking,
        Icons.kitchen,
        Icons.snowboarding,
      ],
      rating: 7.2,
      numberReviews: 178,
      address: "Zermatt, Switzerland",
    ),
  ];
}
