import 'package:flutter_test/flutter_test.dart';
import 'package:ibeacon_wrapper/ibeacon_wrapper.dart';

void main() {
  group('DistanceEstimator', () {
    test('returns -1 when RSSI is zero', () {
      final double result = DistanceEstimator.estimateMeters(
        rssi: 0,
        txPower: -59,
      );
      expect(result, -1.0);
    });

    test('uses ratio^10 branch when ratio is less than 1', () {
      final double result = DistanceEstimator.estimateMeters(
        rssi: -40,
        txPower: -59,
      );
      expect(result, greaterThan(0));
      expect(result, lessThan(1));
    });

    test('uses curve-fit branch when ratio is >= 1', () {
      final double result = DistanceEstimator.estimateMeters(
        rssi: -75,
        txPower: -59,
      );
      expect(result, greaterThan(1));
    });
  });

  group('RssiMovingAverage', () {
    test('computes moving average over configured window', () {
      final RssiMovingAverage average = RssiMovingAverage(windowSize: 3);

      expect(average.add(-60), -60);
      expect(average.add(-63), -62);
      expect(average.add(-66), -63);
      expect(average.add(-69), -66);
    });
  });
}
