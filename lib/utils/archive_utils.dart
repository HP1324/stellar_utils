import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path/path.dart';

class ArchiveUtils {
  static final archive = Archive();

  /// Takes a list of [files] and [directories] and generates a zip file at [path]
  static Future<File> zip({
    List<File> files = const [],
    List<Directory> directories = const [],
    required String path,
  }) async {
    // First add data files in the archive
    for (final file in files) {
      final fileBytes = await file.readAsBytes();
      final fileName = file.uri.pathSegments.last;

      archive.addFile(ArchiveFile.bytes(fileName, fileBytes));
    }

    for (final dir in directories) {
      final baseName = dir.uri.pathSegments.last;

      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          final bytes = await entity.readAsBytes();

          final relativePath = entity.path.substring(dir.path.length + 1);

          final zipPath = join(baseName, relativePath);

          archive.add(ArchiveFile.bytes(zipPath, bytes));
        }
      }
    }

    // encode archive as a Uint8List bytes using ZipEncoder.encodeBytes
    final zipBytes = ZipEncoder().encodeBytes(archive);

    return await File(path).writeAsBytes(zipBytes);
  }

  /// Unzips a file at [zipPath] to the [destinationDirectory].
  static Future<void> unzip({
    required String zipPath,
    required String destinationDirectory,
  }) async {
    final bytes = await File(zipPath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        await (File(
          join(destinationDirectory, filename),
        )..create(recursive: true)).writeAsBytes(data);
      } else {
        await Directory(
          join(destinationDirectory, filename),
        ).create(recursive: true);
      }
    }
  }
}
