class LoginFormCredentials {
  final String? username;
  final String? password;
  final String? totp;

  LoginFormCredentials({this.username, this.password, this.totp});

  LoginFormCredentials copyWith(
      {String? username, String? password, String? totp}) {
    return LoginFormCredentials(
      username: username ?? this.username,
      password: password ?? this.password,
      totp: totp ?? this.totp,
    );
  }
}
