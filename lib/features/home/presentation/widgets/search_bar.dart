import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearchTap;
  final VoidCallback? onFilterTap;
  final String hintText;

  const SearchBarWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.onSearchTap,
    this.onFilterTap,
    this.hintText = "جستجو در محصولات",
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: onFilterTap,
              icon: Icon(Icons.tune, color: theme.colorScheme.outline),
            ),
            SizedBox(
              height: 24,
              child: VerticalDivider(
                color: theme.colorScheme.outline,
                thickness: 1,
                width: 20,
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                textDirection: TextDirection.rtl,
                onChanged: onChanged,
                decoration: InputDecoration(
                  filled: false,
                  hintTextDirection: TextDirection.rtl,
                  hintText: hintText,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            IconButton(
              onPressed: onSearchTap,
              icon: Icon(Icons.search, color: theme.colorScheme.outline),
            ),
          ],
        ),
      ),
    );
  }
}
