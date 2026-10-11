enum FieldType {
  text,
  number,
  date;

  String get labelRu {
    switch (this) {
      case FieldType.text:
        return 'Текст';
      case FieldType.number:
        return 'Число';
      case FieldType.date:
        return 'Дата';
    }
  }

  static FieldType fromName(String name) {
    return FieldType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => FieldType.text,
    );
  }
}
