import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum LoginStatus { initial, success, loading, failure, token }

abstract class LoginEvent {
  final String? username;
  final String? password;
  final BuildContext? context;
  final String? token;

  LoginEvent({this.username, this.password, this.context, this.token});
}

class LoginSubmitted extends LoginEvent {
  LoginSubmitted(
      {required String username,
      required String password,
      required BuildContext context})
      : super(username: username, password: password, context: context);
}

class LogoutRequested extends LoginEvent {
  LogoutRequested({required BuildContext context}) : super(context: context);
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      // ... (lógica para LoginSubmitted)
      emit(LoginLoading());
      try {
        http.Response response;
        response = await _performLogin(
            event.password!, event.username!, event.context!);
        if (response.statusCode == 200 || response.statusCode == 201) {
          print('si success');
          Map<String, dynamic> responseData = json.decode(response.body);
          String token = responseData['token'];

          // Analizar la respuesta JSON para obtener el token.
          emit(LoginSuccess(token: token));
        } else if (response.statusCode == 400) {
          emit(LoginFailure(
              error:
                  'Contraseña y Usuario podrian ser incorrectos, favor de checar datos'));
          // Muestra un mensaje de error en caso de credenciales incorrectas.
        }
      } catch (e) {
        emit(LoginFailure(
            error: 'Ha ocurrido algun error, lo estamos resolviendo'));
      }
    });

    on<LogoutRequested>((event, emit) async {
      // Manejador para LogoutRequested
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');

        Navigator.pushNamedAndRemoveUntil(
            event.context!, '/login', (route) => false);
        emit(LoginInitial());
      } catch (e) {
        emit(LoginFailure(error: '$e'));
      } // Restablecer el estado a LoginInitial
    });
  }

  _performLogin(String pass, String user, BuildContext context) async {
    // Construir el cuerpo de la solicitud en formato JSON.
    Map<String, dynamic> requestBody = {
      'email': user,
      'password': pass,
    };

    final response = await http.post(
      Uri.parse('https://data-fire-product.up.railway.app/Api/v1/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );

    // Verificar si la solicitud fue exitosa (código de estado 200).
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Analizar la respuesta JSON para obtener el token.

      return response;
    } else {
      return response;
      // Muestra un mensaje de error en caso de credenciales incorrectas.
    }
  }
}

class LoginState {
  final LoginStatus status;

  LoginState({required this.status});
}

class LoginInitial extends LoginState {
  LoginInitial() : super(status: LoginStatus.initial);
}

class LoginLoading extends LoginState {
  LoginLoading() : super(status: LoginStatus.loading);
}

class LoginSuccess extends LoginState {
  final String token; // Incluir el token en el estado de éxito

  LoginSuccess({required this.token}) : super(status: LoginStatus.success);
}

class LoginFailure extends LoginState {
  final String? error;

  LoginFailure({this.error}) : super(status: LoginStatus.failure);
}
