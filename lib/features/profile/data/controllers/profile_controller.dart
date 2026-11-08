import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:madang/app/routes/app_routes.dart';
import 'package:madang/core/errors/auth_exceptions.dart';
import 'package:madang/core/widgets/app_snackbar.dart';
import 'package:madang/features/auth/data/repositories/auth_repository.dart';
import 'package:madang/features/auth/data/models/user_model.dart';
import 'package:madang/features/profile/data/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  ProfileController({
    ProfileRepository? repository,
    AuthRepository? authRepository,
  }) : _repository = repository ?? ProfileRepository(),
       _authRepository = authRepository ?? AuthRepository.instance;

  final ProfileRepository _repository;

  final AuthRepository _authRepository;
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxBool isSaving = false.obs;
  final RxBool isLoggingOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      user.value = await _authRepository.fetchUserName();
    } catch (_) {
      // The screen falls back to the Firebase Auth values.
    }
  }

  String get displayName {
    final name = user.value?.name ?? '';
    if (name.isNotEmpty) return name;
    return FirebaseAuth.instance.currentUser?.displayName ?? '';
  }

  String get email {
    final value = user.value?.email ?? '';
    if (value.isNotEmpty) return value;
    return FirebaseAuth.instance.currentUser?.email ?? '';
  }

  String get photoUrl => FirebaseAuth.instance.currentUser?.photoURL ?? '';

  String get initial {
    final name = displayName.trim();
    return name.isEmpty ? '' : name.substring(0, 1).toUpperCase();
  }

  Future<String?> updateUsername(String value) async {
    if (isSaving.value) return null;

    isSaving.value = true;
    try {
      final name = await _repository.updateName(value);

      final current = user.value;
      user.value = UserModel(
        id: current?.id ?? FirebaseAuth.instance.currentUser?.uid ?? '',
        name: name,
        email: current?.email ?? email,
        createdAt: current?.createdAt,
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Could not update your profile. Please try again.';
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> logout() async {
    if (isLoggingOut.value) return;

    isLoggingOut.value = true;
    try {
      await _authRepository.logout();
      Get.offAllNamed(AppRoutes.login);
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('Could not log out. Please try again.');
    } finally {
      isLoggingOut.value = false;
    }
  }

  void _showError(String message) {
    final context = Get.context;
    if (context != null) AppSnackBar.error(context, message);
  }
}
