// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:hotelino/features/home/presentation/provider/profile_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        print(picked.path);
        _image = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final profile = profileProvider.profile;

        if (profile == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                        radius: 55,
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : NetworkImage(profile.avatarUrl) as ImageProvider),
                    Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryFixed, shape: BoxShape.circle),
                            child: Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  profile.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  profile.email,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.grey),
                ),
                SizedBox(
                  height: 24,
                ),
              ],
            ),
          )),
        );
      },
    );
  }
}
