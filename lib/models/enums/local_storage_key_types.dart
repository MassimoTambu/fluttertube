enum LocalStorageKeyTypes {
  FirstRun,
  DownloadDir,
  AudioFormat,
  VideoFormat,
  None,
}

extension ParseToString on LocalStorageKeyTypes {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
