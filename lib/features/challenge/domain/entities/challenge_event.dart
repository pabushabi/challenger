import 'package:equatable/equatable.dart';

class ChallengeEvent extends Equatable {
  const ChallengeEvent({
    required this.id,
    required this.challengeId,
    required this.createdAt,
    required this.values,
  });

  final String id;
  final String challengeId;
  final DateTime createdAt;

  /// fieldDefId → value
  final Map<String, String> values;

  String? get title => values.values.isEmpty ? null : _titleFromValues();

  String? _titleFromValues() {
    for (final entry in values.entries) {
      final value = entry.value.trim();
      if (value.isNotEmpty && !_looksLikeIsoDate(value)) {
        return value;
      }
    }
    return values.values.where((v) => v.trim().isNotEmpty).firstOrNull;
  }

  bool _looksLikeIsoDate(String value) {
    return RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(value);
  }

  @override
  List<Object?> get props => [id, challengeId, createdAt, values];
}
