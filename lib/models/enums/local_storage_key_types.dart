enum LocalStorageKeyTypes {
  DownloadDir,
  AudioFormat,
  VideoFormat,
}

extension ParseToString on LocalStorageKeyTypes {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
