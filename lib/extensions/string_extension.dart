extension StringExtension on String {
  /// Converts a string to a list of integers.
  List<int> toIntList() {
    return split(',').map(int.parse).toList();
  }

  /// Converts a string to a list of doubles.
  List<double> toDoubleList() {
    return split(',').map(double.parse).toList();
  }

  /// Converts a string to a list of strings.
  List<String> toStringList() {
    return split(',');
  }

  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
