import 'dart:collection';
import 'dart:math' as math;

class DistanceEstimator {
  const DistanceEstimator._();

  static double estimateMeters({required int rssi, required int txPower}) {
    if (rssi == 0 || txPower == 0) {
      return -1.0;
    }

    final double ratio = rssi / txPower;

    if (ratio < 1.0) {
      return math.pow(ratio, 10).toDouble();
    }

    return 0.89976 * math.pow(ratio, 7.7095).toDouble() + 0.111;
  }
}

class RssiMovingAverage {
  RssiMovingAverage({this.windowSize = 5}) : assert(windowSize > 0);

  final int windowSize;
  final Queue<int> _samples = Queue<int>();
  int _sum = 0;

  int add(int value) {
    _samples.addLast(value);
    _sum += value;

    if (_samples.length > windowSize) {
      _sum -= _samples.removeFirst();
    }

    return (_sum / _samples.length).round();
  }

  void clear() {
    _samples.clear();
    _sum = 0;
  }
}
