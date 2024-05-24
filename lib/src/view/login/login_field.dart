import 'package:datafire/src/widgets/colors.dart';
import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  final String hintText;
  final TextEditingController? user;
  final bool? isPass;
  final TextEditingController? pass;
  const LoginField(
      {Key? key,
      required this.hintText,
      this.user,
      this.pass,
      required this.isPass})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: TextFormField(
        controller: isPass == false ? user : pass,
        obscureText: isPass == true ? true : false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ingresa datos porfavor';
          }
          return null;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(27),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Pallete.borderColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Pallete.gradient2,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
