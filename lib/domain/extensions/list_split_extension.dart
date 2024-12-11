extension ListSplitExtension<T> on List<T> {
  List<List<T>> split(
    final bool Function(T element) condition,
  ) {
    final result = <List<T>>[];
    var currentSublist = <T>[];

    for (final item in this) {
      if (condition(item)) {
        if (currentSublist.isNotEmpty) {
          result.add(currentSublist);
          currentSublist = [];
        }
      } else {
        currentSublist.add(item);
      }
    }

    if (currentSublist.isNotEmpty) {
      result.add(currentSublist);
    }

    return result;
  }
}
