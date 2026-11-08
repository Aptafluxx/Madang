import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madang/core/widgets/custom_bottom_sheet.dart';
import 'package:madang/core/widgets/custom_button.dart';
import 'package:madang/core/widgets/custom_text_field.dart';
import 'package:madang/features/profile/data/controllers/profile_controller.dart';

/// "Edit" on the profile: change the name.
/// Returns true when the name was saved.
///
/// ```dart
/// final saved = await ProfileEditSheet.show(context, controller: controller);
/// ```
class ProfileEditSheet {
  const ProfileEditSheet._();

  static Future<bool?> show(
    BuildContext context, {
    required ProfileController controller,
  }) {
    return CustomBottomSheet.show<bool>(
      context,
      title: 'Edit profile',
      child: _EditNameForm(controller: controller),
    );
  }
}

class _EditNameForm extends StatefulWidget {
  const _EditNameForm({required this.controller});

  final ProfileController controller;

  @override
  State<_EditNameForm> createState() => _EditNameFormState();
}

class _EditNameFormState extends State<_EditNameForm> {
  late final TextEditingController _text = TextEditingController(
    text: widget.controller.displayName,
  );
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    final error = await widget.controller.updateUsername(_text.text);
    if (!mounted) return;

    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Name',
          hintText: 'Your name',
          controller: _text,
          autofocus: true,
          prefixIcon: Icons.person_outline,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          errorText: _error,
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
          onFieldSubmitted: (_) => _save(),
        ),
        const SizedBox(height: 24),
        Obx(
          () => CustomButton(
            label: 'Save',
            isLoading: widget.controller.isSaving.value,
            onPressed: _save,
          ),
        ),
      ],
    );
  }
}
