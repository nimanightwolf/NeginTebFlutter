// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:neginteb/core/theme/theme_provider.dart';
import 'package:neginteb/features/home/presentation/provider/profile_provider.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_none,
                        color: Colors.grey,
                      )),
                  Consumer<ProfileProvider>(
                    builder: (context, profileProvider, child) {
                      return profileProvider.profile?.notifications != null &&
                              profileProvider.profile!.notifications > 0
                          ? Positioned(
                              right: 12,
                              top: 14,
                              child: CircleAvatar(
                                radius: 4,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          : SizedBox();
                    },
                  )
                ],
              ),
              IconButton(
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                  icon: Icon(
                    themeProvider.brightness == Brightness.light ? Icons.dark_mode : Icons.light_mode,
                    color: Colors.grey,
                  ))
            ],
          ),
          Consumer<ProfileProvider>(
            builder: (context, profileProvider, child) {
              return Row(
                children: [
                  Text(
                    profileProvider.profile?.name ?? 'کاربر',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(profileProvider.profile?.avatarUrl ??
                        "https://www.w3schools.com/howto/img_avatar.png"),
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
