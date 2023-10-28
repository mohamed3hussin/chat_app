

abstract class RegisterStates{}

class RegisterInitialState extends RegisterStates{}
class RegisterLoadingState extends RegisterStates{}
class RegisterSuccessState extends RegisterStates {}
class RegisterErrorState extends RegisterStates
{
  final String error;

  RegisterErrorState(this.error);
}

class RegisterShowPasswordState extends RegisterStates{}

class CreateSuccessState extends RegisterStates
{
  final String uid;

  CreateSuccessState(this.uid);
}
class CreateErrorState extends RegisterStates
{
  final String error;

  CreateErrorState(this.error);
}