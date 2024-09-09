import 'package:formz/formz.dart';

// Define input validation errors
enum UbicationError { empty, length }

// Extend FormzInput and provide the input type and error type.
class Ubication extends FormzInput<String, UbicationError> {
  // Call super.pure to represent an unmodified form input.
  const Ubication.pure() : super.pure("");

  // Call super.dirty to represent a modified form input.
  const Ubication.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == UbicationError.empty) return 'El campo es requerido';
    if (displayError == UbicationError.length) return 'Debe tener por lo menos 8 carácteres';

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  UbicationError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return UbicationError.empty;
    if (value.length < 8) return UbicationError.length;

    return null;
  }
}