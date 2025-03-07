import 'package:hotelino/features/home/data/models/hotel.dart';
import 'package:hotelino/shared/services/json_data_service.dart';

// dependency

class HotelRepository {
  final JsonDataService jsonDataService;

  HotelRepository({required this.jsonDataService});

  Future<List<Hotel>> fetchHotels() async {
    return jsonDataService.loadHotels();
  }

  Future<Hotel> getHotelById(String id) {
    return jsonDataService.loadHotels().then(
      (hotels) {
        return hotels.firstWhere(
          (hotel) => hotel.id == id,
        );
      },
    );
  }
}
