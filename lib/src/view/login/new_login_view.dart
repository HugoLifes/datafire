import 'package:datafire/src/bloc/login_auth_bloc.dart';
import 'package:datafire/src/view/login/login_field.dart';
import 'package:datafire/src/widgets/buttons/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  //LoginScreen({Key? key}) : super(key: key);
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset('assets/images/signin_balls.png'),
              const Text(
                'Bienvenido.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 15),
              LoginField(
                hintText: 'Correo',
                user: _usernameController,
                isPass: false,
              ),
              const SizedBox(height: 15),
              LoginField(
                hintText: 'Contraseña',
                isPass: true,
                pass: _passwordController,
              ),
              const SizedBox(height: 20),
              blocBuilder(context),
              blocListener(),
            ],
          ),
        ),
      ),
    );
  }

  BlocBuilder<LoginBloc, LoginState> blocBuilder(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(builder: (_, state) {
      return GradientButton(
        isLoading: state is LoginLoading,
        onPressed: () {
          context.read<LoginBloc>().add(LoginSubmitted(
              username: _usernameController.text,
              password: _passwordController.text,
              context: context));
        },
      );
    });
  }

  BlocListener<LoginBloc, LoginState> blocListener() {
    return BlocListener<LoginBloc, LoginState>(
      child: Container(),
      listener: (context, state) {
        if (state is LoginSuccess) {
          // Navegar a la siguiente pantalla después de iniciar sesión.
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is LoginFailure) {
          // ... (mostrar mensaje de error)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }
}
