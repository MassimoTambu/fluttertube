enum LocalStorageKeyTypes {
  DownloadDir,
  AudioExtension,
  VideoExtension,
}

extension ParseToString on LocalStorageKeyTypes {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
