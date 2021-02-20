enum AudioFormatTypes {
  Mp3,
  Ogg,
}

enum VideoFormatTypes {
  Avi,
  Mp4,
  Ogg,
}

extension ParseAudioToString on AudioFormatTypes {
  String toShortString() {
    return this.toString().split('.').last.toLowerCase();
  }
}

extension ParseVideoToString on VideoFormatTypes {
  String toShortString() {
    return this.toString().split('.').last.toLowerCase();
  }
}
