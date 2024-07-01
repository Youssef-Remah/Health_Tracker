abstract class BleDeviceStates {}

class BleDeviceInitialState extends BleDeviceStates {}

class BleDeviceConnectionLoadingState extends BleDeviceStates {}

class BleDeviceConnectedSuccessState extends BleDeviceStates {}

class BleDeviceConnectedErrorState extends BleDeviceStates {}

class BleDeviceReconnectedSuccessState extends BleDeviceStates {}

class BleDeviceReconnectedErrorState extends BleDeviceStates {}

class BleDeviceDisconnectedSuccessState extends BleDeviceStates {}

class BleDeviceDisconnectedErrorState extends BleDeviceStates {}

class BleDiscoverServicesSuccessState extends BleDeviceStates {}

class BleDiscoverServicesErrorState extends BleDeviceStates {}

class BleReadHeartRateMeasurementCharacteristicSuccessState extends BleDeviceStates {}

class BleReadHeartRateMeasurementCharacteristicErrorState extends BleDeviceStates {}

class UpdateHealthDataSuccessState extends BleDeviceStates {}

class UpdateHealthDataErrorState extends BleDeviceStates {}

class ReadActivityGoalCharacteristicSuccessState extends BleDeviceStates {}

class ReadActivityGoalCharacteristicErrorState extends BleDeviceStates {}

class GetHealthDataFromDatabaseLoadingState extends BleDeviceStates {}

class GetHealthDataFromDatabaseErrorState extends BleDeviceStates {}