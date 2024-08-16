import 'package:file/src/interface/file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<ImageProvider> getFileFromCache(String url) async {
  final File file;
  final cacheManager = DefaultCacheManager();

  file = await cacheManager.getSingleFile(url);
  return FileImage(file);
}
