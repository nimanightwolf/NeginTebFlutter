// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:neginteb/core/utils/network.dart';
import 'package:neginteb/data/models/product.dart';
import 'package:neginteb/features/home/data/models/hotel.dart';
import 'package:neginteb/features/home/data/repositories/hotel_repository.dart';
import 'package:neginteb/features/home/presentation/widgets/product_card.dart';
import 'package:neginteb/features/hotel_detail/presentation/full_screen_image_shower.dart';
import 'package:neginteb/features/hotel_detail/presentation/full_screen_map_page.dart';
import 'package:neginteb/shared/services/json_data_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../home/presentation/provider/product_provider.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.hotelId});
  final String hotelId;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final hotelRepository = HotelRepository(jsonDataService: JsonDataService());
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder<Product>(
      future: provider.getProductsFromDatabaseById(hotelId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final hotel = snapshot.data!;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: GestureDetector(
                    onLongPress: () {
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: FullScreenImageShower(myImageUrl: hotel.image1),
                          withNavBar: false,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino);
                    },
                    child: Image.network(fit: BoxFit.cover, networkUrl(hotel.image1)),
                  ),
                ),
                elevation: 8,
                expandedHeight: 300,
                leading: IconButton(
                    onPressed: () {
                      PersistentNavBarNavigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        hotel.title,
                        style: textTheme.headlineMedium,
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        " قیمت هر${hotel.unit}  ${hotel.priceVazn}ریال ",
                        style: textTheme.headlineSmall,
                        textDirection: TextDirection.rtl,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              hotel.country,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: Colors.grey,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "امکانات رفاهی",
                        style: textTheme.headlineSmall,
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      // Wrap(
                      //   spacing: 14,
                      //   children: hotel.amenities.map(
                      //     (a) {
                      //       IconData icon;
                      //
                      //       switch (a) {
                      //         case 'ساحل':
                      //           icon = Icons.beach_access;
                      //           break;
                      //
                      //         case 'استخر':
                      //           icon = Icons.pool;
                      //           break;
                      //
                      //         case 'باشگاه':
                      //           icon = Icons.fitness_center;
                      //           break;
                      //
                      //         case 'کافه':
                      //           icon = Icons.restaurant;
                      //           break;
                      //
                      //         case 'رستوران':
                      //           icon = Icons.restaurant;
                      //           break;
                      //
                      //         case 'کولر':
                      //           icon = Icons.ac_unit;
                      //           break;
                      //
                      //         default:
                      //           icon = Icons.check_circle_outline;
                      //       }
                      //
                      //       return Column(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Container(
                      //             padding: EdgeInsets.all(12),
                      //             decoration: BoxDecoration(
                      //               color: Colors.grey.shade200,
                      //               borderRadius: BorderRadius.circular(16),
                      //             ),
                      //             child: Icon(
                      //               icon,
                      //               size: 30,
                      //               color: Colors.grey,
                      //             ),
                      //           ),
                      //           SizedBox(height: 6),
                      //           Text(
                      //             a,
                      //             style: textTheme.bodySmall!.copyWith(color: Colors.black87),
                      //             textDirection: TextDirection.rtl,
                      //           ),
                      //         ],
                      //       );
                      //     },
                      //   ).toList(),
                      // ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "گالری تصاویر",
                        style: textTheme.headlineSmall,
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          itemCount: hotel.image1.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    PersistentNavBarNavigator.pushNewScreen(context,
                                        screen: FullScreenImageShower(
                                          myImageUrl: hotel.image1[index],
                                        ),
                                        withNavBar: false,
                                        pageTransitionAnimation: PageTransitionAnimation.cupertino);
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      networkUrl(hotel.image1[index]),
                                      width: 120,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                if (index != 0)
                                  SizedBox(
                                    width: 8,
                                  )
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "توضیحات",
                        style: textTheme.headlineSmall,
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        hotel.description,
                        style: textTheme.bodyMedium!.copyWith(height: 1.5),
                        textDirection: TextDirection.rtl,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                // PersistentNavBarNavigator.pushNewScreen(context,
                                //     // screen: FullScreenMapPage(
                                //     //     latitude: hotel.country.latitude,
                                //     //     longitude: hotel.location.longitude,
                                //     //     hotelName: hotel.name),
                                //     withNavBar: false,
                                //     pageTransitionAnimation: PageTransitionAnimation.cupertino);
                              },
                              child: Text(
                                "تمام صفحه",
                                textDirection: TextDirection.rtl,
                              )),
                          Text(
                            "موقعیت مکانی هتل روی نقشه",
                            style: textTheme.headlineSmall,
                            textDirection: TextDirection.rtl,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: FlutterMap(
                            options: MapOptions(
                              initialZoom: 15.0,
                              // initialCenter: LatLng(hotel.location.latitude, hotel.location.longitude),
                              interactionOptions: InteractionOptions(
                                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'ir.dunijet.neginteb',
                              ),
                              MarkerLayer(
                                markers: [
                                  // Marker(
                                  //     point: LatLng(hotel.location.latitude, hotel.location.longitude),
                                  //     width: 80,
                                  //     height: 80,
                                  //     child: Column(
                                  //       children: [
                                  //         Icon(
                                  //           Icons.location_pin,
                                  //           color: Colors.red,
                                  //           size: 40,
                                  //         ),
                                  //         Container(
                                  //           padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                  //           color: Colors.white.withOpacity(0.8),
                                  //           child: Text(
                                  //             hotel.name,
                                  //             style: textTheme.bodySmall!.copyWith(color: Colors.black),
                                  //             textDirection: TextDirection.rtl,
                                  //             textAlign: TextAlign.center,
                                  //             maxLines: 1,
                                  //             overflow: TextOverflow.ellipsis,
                                  //           ),
                                  //
                                  //       ],
                                  //     )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
