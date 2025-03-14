// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
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
                      ))
                ],
              )
            ],
          ),
          Row(
            children: [
              Text(
                'کاربر',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                width: 8,
              ),
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage("https://www.w3schools.com/howto/img_avatar.png"),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
