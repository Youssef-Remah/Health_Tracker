import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_tracker/shared/bloc_observer.dart';
import 'package:health_tracker/shared/components/reusable_components.dart';
import 'package:health_tracker/smartwatch_connection/device_screen/cubit/cubit.dart';
import 'package:health_tracker/smartwatch_connection/device_screen/cubit/states.dart';
import 'package:health_tracker/smartwatch_connection/scan_screen/cubit/cubit.dart';
import 'package:health_tracker/smartwatch_connection/scan_screen/scan_screen.dart';

void main()
{
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());

}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers:
      [
        BlocProvider(create: (BuildContext context) => BleDeviceCubit()),
        BlocProvider(create: (BuildContext context) => ScanCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: false,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.blue,
              ),
              color: Colors.blue,
              centerTitle: true,
            )),
        home: BlocListener<BleDeviceCubit, BleDeviceStates>(
          listener: (context, state)
          {
            if (state is BleDeviceConnectedSuccessState)
            {
              showFlutterToast(
                context: context,
                text: 'Connected Successfully',
                state: ToastStates.SUCCESS,
              );

              BleDeviceCubit.get(context)
                  .reconnectionTimer(BleDeviceCubit.get(context).device!);
            }

            if (state is BleDiscoverServicesSuccessState) {
              BleDeviceCubit.get(context).readHeartRateMeasurements();

              BleDeviceCubit.get(context).readActivityGoal();
            }

            if (state is BleDeviceDisconnectedSuccessState) {
              BleDeviceCubit.get(context).reconnectionTimer(
                  BleDeviceCubit.get(context).device!,
                  cancelTimer: true);

              showFlutterToast(
                context: context,
                text: 'Device Disconnected',
                state: ToastStates.WARNING,
                textColor: Colors.black,
              );
            }
          },
          child: BleDeviceScanScreen(),
        ),
      ),
    );
  }
}
