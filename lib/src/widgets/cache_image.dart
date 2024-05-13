import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

Future<ImageProvider> getFileFromCache(String url) async {
  final file;
  final cacheManager = DefaultCacheManager();

  file = await cacheManager.getSingleFile(url);
  if (file != null) {
    return FileImage(file);
  } else {
    // Handle the case where the image isn't cached yet
    return AssetImage(url); // Use AssetImage as fallback
  }
}
