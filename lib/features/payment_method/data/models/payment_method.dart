/// A way to pay. The list is fixed in the app, so showing it costs no
/// Firestore reads. The logos are drawn by the screen, matched by [id].
class PaymentMethod {
  const PaymentMethod({required this.id, required this.label});

  final String id; // saved on the order
  final String label; // shown to the user

  static const PaymentMethod atmBersama = PaymentMethod(
    id: 'atm_bersama',
    label: 'ATM Bersama',
  );
  static const PaymentMethod gopay = PaymentMethod(id: 'gopay', label: 'Gopay');
  static const PaymentMethod linkAja = PaymentMethod(
    id: 'linkaja',
    label: 'LinkAja',
  );

  static const List<PaymentMethod> all = [atmBersama, gopay, linkAja];

  static PaymentMethod? byId(String? id) {
    for (final method in all) {
      if (method.id == id) return method;
    }
    return null;
  }
}
