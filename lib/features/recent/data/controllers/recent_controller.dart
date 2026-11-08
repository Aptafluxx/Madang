import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:madang/features/payment_method/data/models/order_model.dart';
import 'package:madang/features/recent/data/repositories/recent_repository.dart';

class RecentController extends GetxController {
  RecentController({RecentRepository? repository})
      : _repository = repository ?? RecentRepository();

  final RecentRepository _repository;

  /// Don't re-download orders more often than this unless asked to.
  static const Duration staleAfter = Duration(minutes: 2);

  /// Newest first. The "Oldest" tab simply shows this list reversed.
  final RxList<OrderModel> orders = <OrderModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  DateTime? _lastLoaded;
  StreamSubscription<User?>? _authSub;

  @override
  void onInit() {
    super.onInit();
    // Fires on start and on every sign-in / sign-out, so each user only
    // ever sees their own orders.
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        orders.clear();
        _lastLoaded = null;
      } else {
        refreshOrders();
      }
    });
  }

  @override
  void onClose() {
    _authSub?.cancel();
    super.onClose();
  }

  /// Always reloads. Use after placing an order and for pull-to-refresh.
  Future<void> refreshOrders() => _load();

  /// Reloads only if the list is older than [staleAfter]
  /// (use when the Recent tab is opened).
  Future<void> loadIfStale() async {
    final last = _lastLoaded;
    if (last != null && DateTime.now().difference(last) < staleAfter) return;
    await _load();
  }

  Future<void> _load() async {
    if (isLoading.value) return;

    isLoading.value = true;
    errorMessage.value = null;
    try {
      orders.assignAll(await _repository.getMyOrders());
      _lastLoaded = DateTime.now();
    } on FirebaseException catch (e) {
      // For 'failed-precondition' the message contains the index link.
      errorMessage.value = switch (e.code) {
        'permission-denied' => 'You do not have permission to view orders.',
        'failed-precondition' =>
          'Orders are temporarily unavailable. Please try again later.',
        'unavailable' => 'Network error. Please check your internet connection.',
        _ => 'Could not load your orders. Please try again.',
      };
    } catch (_) {
      errorMessage.value = 'Something went wrong. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }
}
