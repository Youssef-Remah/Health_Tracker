import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_tracker/smartwatch_connection/device_screen/device_details_screen.dart';
import 'package:health_tracker/smartwatch_connection/scan_screen/cubit/cubit.dart';
import 'package:health_tracker/smartwatch_connection/scan_screen/cubit/states.dart';
import 'package:shimmer/shimmer.dart';

class BleDeviceScanScreen extends StatelessWidget {
  const BleDeviceScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScanCubit, ScanStates>(

      listener: (BuildContext context, ScanStates state)
      {
      },

      builder: (BuildContext context, ScanStates state) {

        ScanCubit cubit = ScanCubit.get(context);

        return Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20.0, right: 20),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              radius: 30,
              child: FloatingActionButton(
                onPressed: () {
                  // Trigger the start of BLE device scanning
                  cubit.startScanning(context);
                },
                child: const Icon(
                  Icons.bluetooth_searching_outlined,
                  size: 30,
                ),
              ),
            ),
          ),

          appBar: AppBar(
            title: const Text('Scan BLE Devices'),
          ),

          body: state is ScanDevicesInitialState ? ListView.builder( // Show a list of shimmering skeleton items while scanning
            itemCount: 10, // Number of skeleton items to display
            itemBuilder: (context, index)
            {
              return const ShimmeringSkeletonListTile();
            },
          ) :

          cubit.devicesList.isNotEmpty ? ListView.builder(
            itemCount: cubit.devicesList.length,
            itemBuilder: (context, index)
            {
              final deviceName = cubit.devicesList[index]['name'];
              final displayName = deviceName.isNotEmpty
                  ? deviceName
                  : 'Unknown Device Name';
              return ListTile(
                // Leading icon (avatar) with the first letter of the device name or '?' if name is empty
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    displayName[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                // Device name (or 'Unknown Device Name' if name is empty)
                title: Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // MAC address of the device
                subtitle: Text(
                  '${cubit.devicesList[index]['mac']}',
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                  ),
                ),
                // Trailing icon indicating the option to navigate to details
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
                // Navigate to the DeviceDetailsScreen when tapped
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeviceDetailsScreen(
                        device: cubit.devicesList[index]['device'],
                      ),
                    ),
                  );
                },
              );
            },
          )
              : const Center(
            child: Text(
              'No devices found',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      },
    );
  }
}

/// A widget representing a shimmering skeleton list tile.
/// This widget simulates the loading state with a shimmer effect.
class ShimmeringSkeletonListTile extends StatelessWidget {
  const ShimmeringSkeletonListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding around the skeleton tile
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      // Shimmer effect for the skeleton tile
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        // Base color of the skeleton
        highlightColor: Colors.grey[100]!,
        // Highlight color for the shimmer effect
        child: Row(
          children: [
            // Leading circular avatar placeholder
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            // Title and subtitle placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  // Title placeholder
                  Container(
                    width: double.infinity,
                    height: 16.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle placeholder
                  Container(
                    width: 150.0,
                    height: 14.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
