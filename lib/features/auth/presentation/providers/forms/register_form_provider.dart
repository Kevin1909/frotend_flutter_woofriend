import 'package:formz/formz.dart';
import 'package:riverpod/riverpod.dart';
import 'package:woofriend/features/auth/presentation/infrastructure/inputs/inputs.dart';

import '../auth_provider.dart';

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  final registerUserCallback =
      ref.watch(authProvider.notifier).registerOrUpdateUser;

  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});

//! 2 - Como implementamos un notifier
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Future<bool> Function(Map<String, dynamic>) registerUserCallback;

  RegisterFormNotifier({
    required this.registerUserCallback,
  }) : super(RegisterFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail,
        isValid: Formz.validate([
          newEmail,
          state.password,
          state.name,
          state.phone,
          state.ubication
        ]));
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([
          newPassword,
          state.email,
          state.name,
          state.phone,
          state.ubication
        ]));
  }

  onNameChanged(String value) {
    final newName = Name.dirty(value);
    state = state.copyWith(
        name: newName,
        isValid: Formz.validate([
          newName,
          state.password,
          state.email,
          state.phone,
          state.ubication
        ]));
  }

  onPhoneChanged(String value) {
    final newPhone = Phone.dirty(value);
    state = state.copyWith(
        phone: newPhone,
        isValid: Formz.validate([
          newPhone,
          state.password,
          state.name,
          state.email,
          state.ubication
        ]));
  }

  onUbicationChanged(String value) {
    final newUbication = Ubication.dirty(value);
    state = state.copyWith(
        ubication: newUbication,
        isValid: Formz.validate([
          newUbication,
          state.password,
          state.name,
          state.phone,
          state.email
        ]));
  }

  void updateUserImage(String photo) {
    state = state.copyWith(photo: photo);
  }

  void updateFirstContent(String firstContent) {
    state = state.copyWith(firstContent: firstContent);
  }

  void updateSecondContent(String secondContent) {
    state = state.copyWith(secondContent: secondContent);
  }

  void updateThirdContent(String thirdContent) {
    state = state.copyWith(thirdContent: thirdContent);
  }

  onFormSubmitRegister(String? rol, String id) async {
    List<String> roles = [];

    _touchEveryField();

    if (!state.isValid) return;

    state = state.copyWith(
      isPosting: true,
    );

    roles.add(rol!);

    Map<String, dynamic> userData = {
      "id": (id == "new") ? null : id,
      "email": state.email.value,
      "password": state.password.value,
      "name": state.name.value,
      "ubication": state.ubication.value,
      "phone": state.phone.value,
      "roles": roles,
      "profile": {
        "firstcontent" : state.firstContent,
        "secondcontent": state.secondContent,
        "thirdcontent": state.thirdContent,
        "photo": state.phone
      }
    };

    final registeredUser = await registerUserCallback(userData);
    if (registeredUser)
      state = state.copyWith(
        userRegistered: true,
      );

    roles.remove(rol);
    state = state.copyWith(
      userRegistered: false,
    );
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final name = Name.dirty(state.name.value);
    final phone = Phone.dirty(state.phone.value);
    final ubication = Ubication.dirty(state.ubication.value);

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        name: name,
        phone: phone,
        ubication: ubication,
        isValid: Formz.validate([email, password, name, phone, ubication]));
  }
}

//! 1 - State del provider
class RegisterFormState {
  final bool isPosting;
  final bool userRegistered;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final Name name;
  final Phone phone;
  final Ubication ubication;
  final String firstContent;
  final String secondContent;
  final String thirdContent;
  final String photo;

  RegisterFormState({
    this.isPosting = false,
    this.userRegistered = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.name = const Name.pure(),
    this.phone = const Phone.pure(),
    this.ubication = const Ubication.pure(),
    this.firstContent = "",
    this.secondContent = "",
    this.thirdContent = "",
    this.photo = ""
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? userRegistered,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
    Name? name,
    Phone? phone,
    Ubication? ubication,
    String? firstContent,
    String? secondContent,
    String? thirdContent,
    String? photo
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        userRegistered: userRegistered ?? this.userRegistered,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        ubication: ubication ?? this.ubication,
        firstContent: firstContent ?? this.firstContent,
        secondContent: secondContent ?? this.secondContent,
        thirdContent: thirdContent ?? this.thirdContent,
        photo: photo ?? this.photo
      );
}
