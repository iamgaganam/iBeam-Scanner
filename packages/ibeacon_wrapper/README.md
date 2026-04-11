# ibeacon_wrapper

Local package that isolates iBeacon scanning implementation details from app domain/presentation layers.

Exports:

- Scanner interface (`IBeaconScanner`)
- Beacon models (`BeaconSignal`, `ScannerStatus`)
- Distance logic (`DistanceEstimator`) using the required RSSI/TX Power curve fit
- RSSI smoothing helper (`RssiMovingAverage`) for noise reduction
