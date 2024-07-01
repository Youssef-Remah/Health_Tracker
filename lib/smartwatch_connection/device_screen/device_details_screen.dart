import 'dart:ui';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:health_tracker/shared/components/reusable_components.dart';
import 'package:health_tracker/smartwatch_connection/device_screen/cubit/cubit.dart';
import 'package:health_tracker/smartwatch_connection/device_screen/cubit/states.dart';

class DeviceDetailsScreen extends StatelessWidget {
  const DeviceDetailsScreen
      ({
    super.key,
    required this.device,
  });

  final BluetoothDevice device;

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<BleDeviceCubit, BleDeviceStates>(

      listener: (BuildContext context, BleDeviceStates state)
      {
        if(state is BleDeviceConnectedErrorState)
        {
          showFlutterToast(
            context: context,
            text: "Couldn't Connect To Device",
            state: ToastStates.ERROR,
          );
        }
      },

      builder: (BuildContext context, BleDeviceStates state)
      {
        BleDeviceCubit cubit = BleDeviceCubit.get(context);

        BleDeviceCubit.get(context).device = device;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Device Details'),

            actions:
            [
              ConditionalBuilder(
                condition: device.isDisconnected,

                builder: (BuildContext context) => ConditionalBuilder(
                  condition: state is! BleDeviceConnectionLoadingState,

                  builder: (BuildContext context) => TextButton(
                    onPressed: ()
                    {
                      cubit.connectToDevice(device);
                    },
                    child: const Text(
                      'Connect',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),

                  fallback: (BuildContext context) => const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                fallback: (BuildContext context) => TextButton(
                  onPressed: ()
                  {
                    cubit.disconnectDevice(device);
                  },
                  child: const Text(
                    'Disconnect',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ],
          ),

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                  [
                    Text(
                      device.platformName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 21.0,
                      ),
                    ),

                    const SizedBox(
                      height: 15.0,
                    ),

                    Text(
                      device.remoteId.str,
                      style: const TextStyle(
                        fontSize: 19.0,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(
                      height: 40.0,
                    ),

                    Row(
                      children:
                      [
                        Expanded(
                          child: buildHealthDataItem(
                            gradientColor: Colors.red,
                            healthData: cubit.heartRateMeasurement.toString(),
                            titleText: 'Pulse',
                            subScriptText: '  BPM',
                            imagePath: 'lib/assets/images/heart-rate.gif',
                          ),
                        ),

                        const SizedBox(
                          width: 20.0,
                        ),

                        Expanded(
                          child: buildHealthDataItem(
                            gradientColor: Colors.blue,
                            healthData: cubit.distanceCovered.toString(),
                            titleText: 'Distance',
                            subScriptText: '  meter(s)',
                            imagePath: 'lib/assets/images/location.gif',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 40.0,
                    ),

                    Row(
                      children:
                      [
                        Expanded(
                          child: buildHealthDataItem(
                            gradientColor: Colors.black,
                            healthData: cubit.stepsCovered.toString(),
                            titleText: 'Steps',
                            imagePath: 'lib/assets/images/shoes.gif',
                          ),
                        ),

                        const SizedBox(
                          width: 20.0,
                        ),

                        Expanded(
                          child: buildHealthDataItem(
                            gradientColor: Colors.purple,
                            healthData: cubit.caloriesBurnt.toString(),
                            titleText: 'Calories',
                            subScriptText: '  Kcal',
                            imagePath: 'lib/assets/images/calories.gif',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildHealthDataItem({
    required Color gradientColor,
    required String healthData,
    required String titleText,
    String subScriptText = '',
    required String imagePath,
  })
  {
    return Container(
      width: 190.0,
      height: 110.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(15.0),
        boxShadow:
        [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Shadow color
            spreadRadius: 5.0, // Spread radius
            blurRadius: 9.0, // Blur radius
            offset: const Offset(0, 3), // Offset
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors:
          [
            gradientColor.withOpacity(0.55),
            gradientColor.withOpacity(0.6),
            gradientColor.withOpacity(0.65),
            gradientColor.withOpacity(0.7),
            gradientColor.withOpacity(0.85),
            gradientColor.withOpacity(1.0),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
          [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
              [
                Text(
                  titleText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                ),

                Image(image: AssetImage(imagePath)),
              ],
            ),

            Row(
              children:
              [
                Expanded(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    text: TextSpan(
                      children:
                      [
                        TextSpan(
                          text: healthData,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),
                        ),

                        TextSpan(
                          text: subScriptText,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFeatures: [FontFeature.subscripts()]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}