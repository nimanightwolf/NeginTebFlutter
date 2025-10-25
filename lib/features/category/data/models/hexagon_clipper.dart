// hexagon_tile.dart
import 'package:flutter/material.dart';

class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size s) {
    final w = s.width, h = s.height;
    return Path()
      ..moveTo(w * .25, 0)
      ..lineTo(w * .75, 0)
      ..lineTo(w, h * .5)
      ..lineTo(w * .75, h)
      ..lineTo(w * .25, h)
      ..lineTo(0, h * .5)
      ..close();
  }
  @override
  bool shouldReclip(_) => false;
}

class HexagonTile extends StatelessWidget {
  final String title;
  final String image;
  final bool isNetwork;
  final VoidCallback? onTap;

  const HexagonTile({
    super.key,
    required this.title,
    required this.image,
    required this.isNetwork,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    final img = isNetwork
        ? Image.network(image, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported))
        : Image.asset(image, fit: BoxFit.cover);

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            width: 140, height: 120,
            child: Stack(
              children: [
                // سایه‌ی لطیف
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),

                    ),
                  ),
                ),
                Positioned.fill(
                  child: ClipPath(clipper: _HexagonClipper(), child: img),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 150,
            child: Text(title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: t.titleMedium),
          ),
        ],
      ),
    );
  }
}
