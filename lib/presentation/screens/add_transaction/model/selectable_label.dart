import '../../../../data/model/transaction_label.dart';

class SelectableLabel extends TransactionLabel {
  SelectableLabel({
    required this.selected,
    required super.name,
    required super.id,
    required super.weight,
  });
  bool selected;
}
