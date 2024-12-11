class TransactionFilter {
  TransactionFilter({
    this.tags = const [],
    this.labels = const [],
    this.text,
  });

  final List<String> tags;
  final List<String> labels;
  final String? text;

  TransactionFilter copy() {
    return TransactionFilter(
      tags: [...tags],
      labels: [...labels],
      text: text,
    );
  }

  TransactionFilter copyWith({
    final List<String>? tags,
    final List<String>? labels,
    final String? text,
  }) {
    return TransactionFilter(
      tags: tags ?? this.tags,
      labels: labels ?? this.labels,
      text: text ?? this.text,
    );
  }

  bool get hasData {
    return tags.isNotEmpty || labels.isNotEmpty || text != null;
  }

  void clear() {
    tags.clear();
    labels.clear();
  }
}
