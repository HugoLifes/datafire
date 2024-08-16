import 'package:datafire/src/widgets/colors.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  TextEditingController? user = TextEditingController();
  TextEditingController? pass = TextEditingController();
  dynamic onPressed;
  bool? isLoading;
  GradientButton(
      {Key? key, this.user, this.pass, this.onPressed, this.isLoading})
      : super(key: key);

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Pallete.gradient1,
            Pallete.gradient2,
            Pallete.gradient3,
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: widget.isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : const Text(
                'Inicia Sesión',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    fontFamily: 'GoogleSans'),
              ),
      ),
    );
  }
}
