import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/models/enums/file_format_types.dart';
import 'package:fluttertube/models/enums/local_storage_key_types.dart';
import 'package:fluttertube/utils/helpers/dialogs_helper.dart';
import 'package:fluttertube/utils/services/local_storage_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;

class FTDownloader {
  yt.Video videoInfo;
  yt.StreamManifest streamManifest;
  AudioFormatTypes audioFormat;
  VideoFormatTypes videoFormat;

  FTDownloader({
    this.videoInfo,
    this.streamManifest,
    this.audioFormat,
    this.videoFormat,
  });

  /// Download the YT stream following manifest and audio, video formats previously setted.
  Future<void> download({
    @required yt.StreamInfo streamToDownload,
    BuildContext context,
    Future<bool> Function(BuildContext) onFileExists = _onFileExists,
    void Function() onInitDownload,
    void Function() onEndDownload,
  }) async {
    if (audioFormat == null && videoFormat == null) {
      throw 'File format not selected';
    }
    //TODO chiama servizio per prendere il path
    final file = File(await _buildFileNamePath());

    try {
      if (await file.exists()) {
        if (!await onFileExists(context)) {
          return;
        }
        file.writeAsBytesSync([]);
      }

      final yte = yt.YoutubeExplode();

      onInitDownload();

      final stream = yte.videos.streamsClient.get(streamToDownload);

      // Open a file for writing.
      final fileStream = file.openWrite();

      // Pipe all the content of the stream into the file.
      await stream.pipe(fileStream);

      // Close the file.
      await fileStream.flush();
      await fileStream.close();

      yte.close();
    } on FileSystemException catch (fsException) {
      //TODO ERROR DIALOG
      throw fsException;
    } catch (e) {
      //TODO ERROR DIALOG
      throw e;
    } finally {
      onEndDownload();
    }
  }

  static Future<bool> _onFileExists(BuildContext context) async {
    return await DialogsHelper.showQuestionDialog(
      context,
      title: 'File già presente',
      content: 'Questo file esiste già, vuoi sovrascriverlo?',
      actionTextAcceptance: 'Sì',
      actionTextRefusal: 'No',
    );
  }

  Future<String> _buildFileNamePath() async {
    final downloadDirKey = LocalStorageKeyTypes.DownloadDir.toShortString();
    final dir = await LocalStorageService.getValue<String>(downloadDirKey);

    String fullFileName;

    // Check File Format
    if (videoFormat != null) {
      fullFileName = '$dir/${videoInfo.title}.${videoFormat.toShortString()}';
    } else {
      fullFileName = '$dir/${videoInfo.title}.${audioFormat.toShortString()}';
    }

    return fullFileName;
  }
}
