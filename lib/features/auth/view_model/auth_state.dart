abstract class AuthStates {}

final class AuthInitial extends AuthStates {}
final class AuthRememberMeToggle extends AuthStates {}
final class AuthShowPasswordToggle extends AuthStates {}