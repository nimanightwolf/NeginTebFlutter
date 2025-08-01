import 'package:flutter/material.dart';
import 'package:neginteb/core/utils/network.dart';
import 'package:neginteb/core/utils/price_formatter.dart';
import 'package:neginteb/features/home/data/models/hotel.dart';

class FavoriteHotelCard extends StatelessWidget {
  final Hotel hotel;
  Function(String) onRemoveFavotiteClicked;

  FavoriteHotelCard({super.key, required this.hotel, required this.onRemoveFavotiteClicked});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (Theme.of(context).brightness == Brightness.light)
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              spreadRadius: 2,
            )
          else
            BoxShadow(
              color: Theme.of(context).colorScheme.surfaceContainerHigh.withValues(alpha: 1),
              blurRadius: 6,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 12),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("جزِئیات", style: TextStyle(color: Colors.white)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 4),
                      Text(hotel.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("${hotel.city}, ${hotel.country}"),
                          const SizedBox(width: 5),
                          Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary, size: 18),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${hotel.bedType.count} ${hotel.bedType.details}",
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(width: 5),
                          Icon(Icons.bed, color: Theme.of(context).colorScheme.primary, size: 18),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text("از ${formatPrice(hotel.pricePerNight)} / شب",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                child: Image.network(
                  networkUrl(hotel.images[0]),
                  width: 100,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Positioned(
            left: 16,
            top: 16,
            child: GestureDetector(
              onTap: () => onRemoveFavotiteClicked(hotel.id),
              child: const Icon(
                Icons.favorite,
                size: 24,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
