import 'package:formz/formz.dart';

// Define input validation errors
enum CharacteristicsError { empty, length }

// Extend FormzInput and provide the input type and error type.
class Characteristics extends FormzInput<String, CharacteristicsError> {
  // Call super.pure to represent an unmodified form input.
  const Characteristics.pure() : super.pure("");

  // Call super.dirty to represent a modified form input.
  const Characteristics.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == CharacteristicsError.empty) return 'El campo es requerido';
    if (displayError == CharacteristicsError.length) return 'Por lo menos 30 carácteres';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  CharacteristicsError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return CharacteristicsError.empty;
    if (value.length < 30) return CharacteristicsError.length;

    return null;
  }
}