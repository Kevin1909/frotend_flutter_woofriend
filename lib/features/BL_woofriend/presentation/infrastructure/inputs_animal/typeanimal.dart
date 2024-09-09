import 'package:formz/formz.dart';

// Define input validation errors
enum TypeAnimalError { empty }

// Extend FormzInput and provide the input type and error type.
class TypeAnimal extends FormzInput<String, TypeAnimalError> {



  // Call super.pure to represent an unmodified form input.
  const TypeAnimal.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const TypeAnimal.dirty( String value ) : super.dirty(value);



  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == TypeAnimalError.empty ) return 'El campo es requerido';
    

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  TypeAnimalError? validator(String value) {
    
    if ( value.isEmpty || value.trim().isEmpty ) return TypeAnimalError.empty;

    return null;
  }
}