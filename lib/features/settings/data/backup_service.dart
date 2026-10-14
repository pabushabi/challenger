import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:kinochallenge/features/challenge/domain/repositories/challenge_repository.dart';
import 'package:kinochallenge/features/settings/data/settings_repository.dart';
import 'package:kinochallenge/features/settings/domain/entities/backup_export_mode.dart';
import 'package:kinochallenge/features/settings/domain/entities/backup_payload.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

enum BackupExportResult {
  success,
  cancelled,
}

class BackupService {
  BackupService({
    required ChallengeRepository challengeRepository,
    required SettingsRepository settingsRepository,
  })  : _challengeRepository = challengeRepository,
        _settingsRepository = settingsRepository;

  final ChallengeRepository _challengeRepository;
  final SettingsRepository _settingsRepository;

  Future<BackupExportResult> exportBackup(BackupExportMode mode) async {
    final stamp = DateFormat('yyyy-MM-dd_HH-mm').format(DateTime.now());
    final fileName = 'challenger_backup_$stamp.json';
    final json = await _buildBackupJson();
    final bytes = Uint8List.fromList(utf8.encode(json));

    switch (mode) {
      case BackupExportMode.saveToDevice:
        return _saveToDevice(fileName: fileName, bytes: bytes);
      case BackupExportMode.share:
        return _share(fileName: fileName, json: json);
    }
  }

  Future<String> _buildBackupJson() async {
    final payload = BackupPayload(
      version: BackupPayload.currentVersion,
      exportedAt: DateTime.now(),
      settings: _settingsRepository.load(),
      challenge: await _challengeRepository.getActiveChallenge(),
    );
    return const JsonEncoder.withIndent('  ').convert(payload.toJson());
  }

  Future<BackupExportResult> _saveToDevice({
    required String fileName,
    required Uint8List bytes,
  }) async {
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Сохранить бэкап',
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: const ['json'],
      bytes: bytes,
    );

    if (path == null) {
      return BackupExportResult.cancelled;
    }

    // На части платформ bytes уже записаны; на других нужно дописать вручную.
    final file = File(path);
    if (!await file.exists() || await file.length() == 0) {
      await file.writeAsBytes(bytes, flush: true);
    }
    return BackupExportResult.success;
  }

  Future<BackupExportResult> _share({
    required String fileName,
    required String json,
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, fileName));
    await file.writeAsString(json);

    final result = await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'application/json')],
        subject: 'Бэкап CHALLENGER',
        text: 'Резервная копия челленджа, истории и настроек',
      ),
    );

    if (result.status == ShareResultStatus.unavailable) {
      throw StateError('Не удалось открыть меню «Поделиться»');
    }
    if (result.status == ShareResultStatus.dismissed) {
      return BackupExportResult.cancelled;
    }
    return BackupExportResult.success;
  }

  /// Возвращает null, если пользователь отменил выбор файла.
  Future<BackupPayload?> pickBackup() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: true,
    );

    if (picked == null || picked.files.isEmpty) {
      return null;
    }

    final file = picked.files.single;
    final bytes = file.bytes;
    final String raw;
    if (bytes != null) {
      raw = utf8.decode(bytes);
    } else if (file.path != null) {
      raw = await File(file.path!).readAsString();
    } else {
      throw const FormatException('Не удалось прочитать файл бэкапа');
    }

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Некорректный формат бэкапа');
    }
    return BackupPayload.fromJson(decoded);
  }

  Future<void> applyBackup(BackupPayload payload) async {
    await _challengeRepository.restoreFromSnapshot(
      payload.challenge?.copyWith(isActive: true),
    );
    await _settingsRepository.save(payload.settings);
  }
}
