import 'dart:core';


class ApiConstants {
  static const String baseUrl = 'https://shebaai.pythonanywhere.com/api';
  
  //endpoints
  static const String register = '/accounts/auth/register/';
  static const String login = '/accounts/auth/login/';
  static const String refresh = '/accounts/auth/refresh/';
  static const String profile = '/accounts/auth/profile/';
}