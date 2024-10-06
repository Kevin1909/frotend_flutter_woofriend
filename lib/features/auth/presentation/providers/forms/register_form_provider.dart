import 'package:formz/formz.dart';
import 'package:riverpod/riverpod.dart';
import 'package:woofriend/features/auth/domain/entities/user.dart';
import 'package:woofriend/features/auth/presentation/infrastructure/inputs/inputs.dart';
import 'package:woofriend/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

import '../../../../shared/infrastructure/services/key_value_storage_service.dart';
import '../auth_provider.dart';

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  final registerUserCallback =
      ref.watch(authProvider.notifier).registerOrUpdateUser;
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return RegisterFormNotifier(
      registerUserCallback: registerUserCallback,
      keyValueStorageService: keyValueStorageService);
});

//! 2 - Como implementamos un notifier
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Future<bool> Function(
    Map<String, dynamic>, [String? id]
  ) registerUserCallback;

  final KeyValueStorageService keyValueStorageService;

  RegisterFormNotifier({
    required this.registerUserCallback,
    required this.keyValueStorageService,
  }) : super(RegisterFormState());

  onUpdateUser(User user, String passwordTemp) {
    state = state.copyWith(
        email: (state.email.value == "")
            ? Email.dirty(user.email)
            : Email.dirty(state.email.value),
        password: (state.password.value == "")
            ? Password.dirty(passwordTemp)
            : Password.dirty(state.password.value),
        ubication: (state.ubication.value == "")
            ? Ubication.dirty(user.ubication)
            : Ubication.dirty(state.ubication.value),
        phone: (state.phone.value == "")
            ? Phone.dirty(user.phone)
            : Phone.dirty(state.phone.value),
        name: (state.name.value == "")
            ? Name.dirty(user.name)
            : Name.dirty(state.name.value),
        firstcontent:
            (state.firstcontent == "") ? user.firstcontent : state.firstcontent,
        secondcontent: (state.secondcontent == "")
            ? user.secondcontent
            : state.secondcontent,
        thirdcontent:
            (state.thirdcontent == "") ? user.thirdcontent : state.thirdcontent,
        photo: (state.photo.isEmpty) ? user.photoUser : state.photo);
  }

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
    const Email.pure();
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

  updateUserImage(String photo) {
    state = state.copyWith(photo: photo);
  }

  void updateFirstContent(String firstContent) {
    state = state.copyWith(firstcontent: firstContent);
  }

  void updateSecondContent(String secondContent) {
    state = state.copyWith(secondcontent: secondContent);
  }

  void updateThirdContent(String thirdContent) {
    state = state.copyWith(thirdcontent: thirdContent);
  }

  Future<bool> onFormSubmitRegister(
    String id, [
    String? rol,
  ]) async {
    List<String> roles = [];

    _touchEveryField();

    if (!state.isValid) return false;

    await Future.delayed(const Duration(milliseconds: 300));

    state = state.copyWith(
      isPosting: true,
    );
    roles.add(rol!);

    Map<String, dynamic> userData = {
      'id': (id == 'new') ? null : id,
      'email': state.email.value,
      'password': state.password.value,
      'name': state.name.value,
      'ubication': state.ubication.value,
      'phone': state.phone.value,
      'roles': roles,
      'firstcontent': state.firstcontent,
      'secondcontent': state.secondcontent,
      'thirdcontent': state.thirdcontent,
      'photo': state.photo
    };
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final registeredUser = await registerUserCallback(
        userData,
        id
      );
      if (registeredUser)
        state = state.copyWith(
          userRegistered: true,
        );

      roles.remove(rol);

      state = state.copyWith(
          isPosting: false, isValid: false, userRegistered: false);
      return registeredUser;
    } catch (e) {
      return false;
    }
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
  final String firstcontent;
  final String secondcontent;
  final String thirdcontent;
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
    this.firstcontent = "",
    this.secondcontent = "",
    this.thirdcontent = "",
    this.photo = "",
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
    String? firstcontent,
    String? secondcontent,
    String? thirdcontent,
    String? photo,
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
        firstcontent: firstcontent ?? this.firstcontent,
        secondcontent: secondcontent ?? this.secondcontent,
        thirdcontent: thirdcontent ?? this.thirdcontent,
        photo: photo ?? this.photo,
      );
}
