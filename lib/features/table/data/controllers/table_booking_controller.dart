import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:madang/features/table/data/models/table_model.dart';

class BookingAddition {
  const BookingAddition(this.name, this.price, {this.allowsQuantity = false});

  final String name;
  final num price;
  final bool allowsQuantity;

  static final NumberFormat _money = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
  );

  String get priceText => price == 0 ? 'Free' : _money.format(price);
}

class TableBookingSelection {
  const TableBookingSelection({
    required this.table,
    required this.duration,
    required this.additions,
  });

  final TableModel table;
  final String duration;
  final Map<String, int> additions;
}

class TableBookingController extends GetxController {
  TableBookingController(this.table);

  final TableModel table;

  static const List<String> durations = [
    '30 minutes',
    '45 minutes',
    '1 hour',
    '2 hour',
  ];

  static String defaultCustomTime = '';

  static const List<BookingAddition> availableAdditions = [
    BookingAddition('Chair', 0),
    BookingAddition('Table', 0),
    BookingAddition('Flower', 2.5, allowsQuantity: true),
  ];

  final RxString selectedDuration = durations.first.obs;
  final RxBool isCustomTime = false.obs;
  final RxnString customTimeError = RxnString();
  final RxSet<String> selectedAdditions = <String>{}.obs;
  final RxMap<String, int> quantities = <String, int>{}.obs;

  void selectDuration(String duration) {
    selectedDuration.value = duration;
    isCustomTime.value = false;
    customTimeError.value = null;
  }

  void enableCustomTime() {
    isCustomTime.value = true;
    selectedDuration.value = defaultCustomTime;
  }

  void setCustomTime(String value) {
    selectedDuration.value = value.trim();
    customTimeError.value = null;
  }

  void toggleAddition(String name, bool checked) {
    if (checked) {
      selectedAdditions.add(name);
      quantities.putIfAbsent(name, () => 1);
    } else {
      selectedAdditions.remove(name);
      quantities.remove(name);
    }
  }

  void setQuantity(String name, int quantity) => quantities[name] = quantity;

  bool validate() {
    if (isCustomTime.value && selectedDuration.value.trim().isEmpty) {
      customTimeError.value = 'Enter a time, e.g. 10 minutes';
      return false;
    }
    customTimeError.value = null;
    return true;
  }

  TableBookingSelection buildSelection() => TableBookingSelection(
    table: table,
    duration: selectedDuration.value,
    additions: {
      for (final name in selectedAdditions) name: quantities[name] ?? 1,
    },
  );
}
