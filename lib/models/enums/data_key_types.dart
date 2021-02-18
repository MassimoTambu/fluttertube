enum DataKeyTypes {
  DownloadDir,
  AudioExtension,
  VideoExtension,
}

extension ParseToString on DataKeyTypes {
  String toShortString() {
    return this.toString().split('.').last;
  }
}
