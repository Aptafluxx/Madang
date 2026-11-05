import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:madang/features/table/data/models/table_model.dart';

final NumberFormat _money = NumberFormat.currency(
  locale: 'en_US',
  symbol: '\$',
);

String formatMoney(num value) => _money.format(value);

class BookingAddition {
  const BookingAddition(this.name, this.price, {this.allowsQuantity = false});

  final String name;
  final num price;
  final bool allowsQuantity;

  String priceTextFor(int quantity) =>
      price == 0 ? 'Free' : formatMoney(price * quantity);
}

class TableBookingSelection {
  const TableBookingSelection({
    required this.table,
    required this.duration,
    required this.additions,
    required this.subtotal,
  });

  final TableModel table;
  final String duration;
  final Map<String, int> additions;
  final num subtotal;
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

  static const String defaultCustomTime = '';

  static const List<BookingAddition> availableAdditions = [
    BookingAddition('Chair', 0),
    BookingAddition('Table', 0),
    BookingAddition('Flower', 2.5, allowsQuantity: true),
  ];

  final RxnString selectedDuration = RxnString();
  final RxBool isCustomTime = false.obs;
  final RxnString timeError = RxnString();
  final RxSet<String> selectedAdditions = <String>{}.obs;
  final RxMap<String, int> quantities = <String, int>{}.obs;

  // ── Time ──────────────────────────────────────────────────────

  void selectDuration(String duration) {
    final alreadySelected =
        !isCustomTime.value && selectedDuration.value == duration;
    isCustomTime.value = false;
    selectedDuration.value = alreadySelected ? null : duration;
    timeError.value = null;
  }

  void enableCustomTime() {
    isCustomTime.value = true;
    selectedDuration.value = defaultCustomTime;
    timeError.value = null;
  }

  void setCustomTime(String value) {
    selectedDuration.value = value.trim();
    timeError.value = null;
  }

  // ── Additions ─────────────────────────────────────────────────

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

  // ── Prices (read these inside Obx so the screen updates) ──────

  num get tablePrice => table.price;

  num get additionsTotal {
    num total = 0;
    for (final addition in availableAdditions) {
      if (selectedAdditions.contains(addition.name)) {
        total += addition.price * (quantities[addition.name] ?? 1);
      }
    }
    return total;
  }

  num get subtotal => tablePrice + additionsTotal;

  // ── Submit ────────────────────────────────────────────────────

  bool validate() {
    final duration = selectedDuration.value?.trim() ?? '';
    if (duration.isEmpty) {
      timeError.value = isCustomTime.value
          ? 'Enter a time, e.g. 10 minutes'
          : 'Please choose how long you will stay';
      return false;
    }
    timeError.value = null;
    return true;
  }

  TableBookingSelection buildSelection() => TableBookingSelection(
    table: table,
    duration: selectedDuration.value?.trim() ?? '',
    additions: {
      for (final name in selectedAdditions) name: quantities[name] ?? 1,
    },
    subtotal: subtotal,
  );
}
