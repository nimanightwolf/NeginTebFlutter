import 'package:neginteb/features/home/data/models/profile.dart';

class ProfileRepository {
  Future<Profile> fetchUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 100));

    return Profile(
      id: "7954862145",
      name: "نیما حیدری",
      email: "kiankhaki@gmail.com",
      avatarUrl: "https://dunijet.ir/content/projects/hotelino/profile_pic.png",
      phoneNumber: "+989123456789",
      location: "تهران، ایران",
      bio: "عاشق سفر و تجربه هتل‌های لاکچری 🌍✨",
      bookings: 12,
      favorites: 5,
      notifications: 3,
    );
  }
}
