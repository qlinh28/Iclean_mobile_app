import 'package:flutter/material.dart';
import 'package:iclean_mobile_app/models/address.dart';
import 'package:iclean_mobile_app/services/api_location_repo.dart';
import 'package:iclean_mobile_app/widgets/my_app_bar.dart';
import 'package:iclean_mobile_app/view/common/location/add_location/add_location_screen.dart';
import 'package:iclean_mobile_app/view/common/location/update_location/update_location_screen.dart';
import 'package:iclean_mobile_app/widgets/my_bottom_app_bar.dart';

import '../../../widgets/confirm_dialog.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiLocationRepository apiLocationRepository = ApiLocationRepository();

    Future<List<Address>> fetchNotifications(
        ApiLocationRepository repository) async {
      try {
        final locations = await repository.getLocation();
        return locations;
      } catch (e) {
        // ignore: avoid_print
        print(e);
        return <Address>[];
      }
    }

    void showConfirmationDialog(BuildContext context, Address location) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfirmDialog(
            title: "Chọn ${location.addressName} làm địa chỉ mặc định",
            confirm: "Xác nhận",
            onTap: () {
              final Map<String, dynamic> dataForUpdate = {
                'locationName': location.addressName,
                'description': location.description,
                'latitude': location.latitude,
                'longitude': location.longitude,
                'isDefault': true,
              };

              apiLocationRepository
                  .updateLocation(location.id!, dataForUpdate)
                  .then((_) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LocationScreen()));
              }).catchError((error) {
                print('Failed to update location: $error');
              });
            },
          );
        },
      );
    }

    void updateLocation() {}

    return Scaffold(
      appBar: const MyAppBar(text: "Vị trí của bạn"),
      body: FutureBuilder<List<Address>>(
        future: fetchNotifications(apiLocationRepository),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Address> locations = snapshot.data ?? [];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  for (int i = 0; i < locations.length; i++)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                InkWell(
                                  // onTap: () => showConfirmationDialog(
                                  //     context, locations[i]),
                                  onTap: () {
                                    if (locations[i].isDefault == false) {
                                      showConfirmationDialog(
                                          context, locations[i]);
                                    }
                                  },

                                  child: Icon(
                                    locations[i].isDefault
                                        ? Icons.circle_rounded
                                        : Icons.circle_outlined,
                                    color: Colors.deepPurple.shade300,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            locations[i].addressName,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Lato',
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          UpdateLocationScreen(
                                                            address:
                                                                locations[i],
                                                            apiLocationRepository:
                                                                apiLocationRepository,
                                                          )));
                                            },
                                            child: const Text(
                                              "Sửa",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Lato',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(locations[i].description,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                            fontFamily: 'Lato',
                                          ),
                                          textAlign: TextAlign.justify,
                                          maxLines: null),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (i != locations.length - 1)
                            Divider(
                              thickness: 0.5,
                              color: Colors.grey[400],
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: MyBottomAppBar(
        text: "Thêm vị trí mới",
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddLocationScreen(
                        apiLocationRepository: apiLocationRepository,
                      )));
        },
      ),
    );
  }
}
