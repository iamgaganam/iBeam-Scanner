class ParsedIBeaconPacket {
  const ParsedIBeaconPacket({
    required this.uuid,
    required this.major,
    required this.minor,
    required this.txPower,
  });

  final String uuid;
  final int major;
  final int minor;
  final int txPower;
}

class IBeaconPacketParser {
  const IBeaconPacketParser._();

  static const int _appleCompanyId = 0x004C;
  static const int _prefixByte0 = 0x02;
  static const int _prefixByte1 = 0x15;

  static ParsedIBeaconPacket? parse(Map<int, List<int>> manufacturerData) {
    final List<int>? payload = manufacturerData[_appleCompanyId];
    if (payload == null || payload.length < 23) {
      return null;
    }

    if (payload[0] != _prefixByte0 || payload[1] != _prefixByte1) {
      return null;
    }

    final List<int> uuidBytes = payload.sublist(2, 18);
    final int major = (payload[18] << 8) | payload[19];
    final int minor = (payload[20] << 8) | payload[21];
    final int txPower = _toSignedByte(payload[22]);

    return ParsedIBeaconPacket(
      uuid: _formatUuid(uuidBytes),
      major: major,
      minor: minor,
      txPower: txPower,
    );
  }

  static int _toSignedByte(int value) {
    return value > 127 ? value - 256 : value;
  }

  static String _formatUuid(List<int> bytes) {
    final StringBuffer buffer = StringBuffer();
    for (final int byte in bytes) {
      buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    }

    final String raw = buffer.toString().toUpperCase();
    return '${raw.substring(0, 8)}-'
        '${raw.substring(8, 12)}-'
        '${raw.substring(12, 16)}-'
        '${raw.substring(16, 20)}-'
        '${raw.substring(20, 32)}';
  }
}
