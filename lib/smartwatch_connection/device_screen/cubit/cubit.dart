import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:health_tracker/smartwatch_connection/device_screen/cubit/states.dart';


class BleDeviceCubit extends Cubit<BleDeviceStates>
{
  BleDeviceCubit() : super(BleDeviceInitialState());

  static BleDeviceCubit get(context) => BlocProvider.of(context);

  List<BluetoothService> services = [];

  BluetoothDevice? device;

  Timer? _timer;

  int heartRateMeasurement = 0;

  int stepsCovered = 0;

  int distanceCovered = 0;

  int caloriesBurnt = 0;


  List<dynamic>? heartRateReadings;

  List<dynamic>? distanceCoveredReadings;

  List<dynamic>? stepsCoveredReadings;

  List<dynamic>? caloriesBurntReadings;


  void connectToDevice(BluetoothDevice device)
  {
    emit(BleDeviceConnectionLoadingState());

    device.connect()
        .then((value)
    {
      emit(BleDeviceConnectedSuccessState());

      discoverBluetoothServices(device);
    })
        .catchError((error)
    {
      emit(BleDeviceConnectedErrorState());
      print(error.toString());
    });
  }

  void reConnectToDevice(BluetoothDevice device)
  {
    device.connect()
        .then((value)
    {
      emit(BleDeviceReconnectedSuccessState());

      discoverBluetoothServices(device);
    })
        .catchError((error)
    {
      emit(BleDeviceReconnectedErrorState());
      print(error.toString());
    });
  }

  void discoverBluetoothServices(BluetoothDevice device)
  {
    device.discoverServices()
    .then((value)
    {
      services = value;
      emit(BleDiscoverServicesSuccessState());

    })
    .catchError((error)
    {
      emit(BleDiscoverServicesErrorState());
      print(error.toString());
    });
  }

  void readHeartRateMeasurementCharacteristic(BluetoothCharacteristic characteristic)
  {
    if (!characteristic.properties.notify)
    {
      //TODO: This if statement for debugging purposes only (remove it later)
      print('This characteristic does not support notifications.');
      return;
    }

    characteristic.setNotifyValue(true).then((_)
    {
      characteristic.lastValueStream.listen((value)
      {
        emit(BleReadHeartRateMeasurementCharacteristicSuccessState());

        if(value.isNotEmpty)
        {
          heartRateMeasurement = value[1];
        }

      });
    }).catchError((error)
    {
      emit(BleReadHeartRateMeasurementCharacteristicErrorState());
      print(error.toString());
    });
  }

  void readHeartRateMeasurements()
  {
    for(BluetoothService service in services)
    {
      if(service.serviceUuid.toString() == '180d') //Heart Rate Service
          {
        for(BluetoothCharacteristic c in service.characteristics)
        {
          if(c.characteristicUuid.toString() == '2a37') //Heart Rate Measurement
              {
            readHeartRateMeasurementCharacteristic(c);

            return;
          }
        }
      }
    }
  }

  void reconnectionTimer(BluetoothDevice device, {bool cancelTimer = false})
  {
    if (cancelTimer)
    {
      _timer?.cancel();
      return;
    }

    const duration = Duration(seconds: 45);
    _timer = Timer.periodic(duration, (Timer timer)
    {
      reConnectToDevice(device);

      // Reset the timer
      timer.cancel();
      reconnectionTimer(device);
    });

  }

  void disconnectDevice(BluetoothDevice device)
  {
    device.disconnect()
        .then((value)
    {
      emit(BleDeviceDisconnectedSuccessState());
    })
        .catchError((error)
    {
      emit(BleDeviceDisconnectedErrorState());
    });
  }


  void readActivityGoal()
  {
    for(BluetoothService service in services)
    {
      if(service.serviceUuid.toString() == 'fee0')
      {
        for(BluetoothCharacteristic c in service.characteristics)
        {
          if(c.characteristicUuid.toString() == '00000007-0000-3512-2118-0009af100700')
          {
            readActivityGoalCharacteristic(c);
          }
        }
      }
    }
  }

  void readActivityGoalCharacteristic(BluetoothCharacteristic characteristic)
  {
    if (!characteristic.properties.notify)
    {
      //TODO: This if statement for debugging purposes only (remove it later)
      print('This characteristic does not support notifications.');
      return;
    }

    characteristic.setNotifyValue(true).then((_)
    {
      characteristic.lastValueStream.listen((value)
      {
        emit(ReadActivityGoalCharacteristicSuccessState());

        if(value.isNotEmpty)
        {
          stepsCovered = value[1] + (value[2] << 8);

          distanceCovered = value[5] + (value[6] << 8);

          caloriesBurnt = value[9];
        }
      });
    }).catchError((error)
    {
      emit(ReadActivityGoalCharacteristicErrorState());
      print(error.toString());
    });
  }

}