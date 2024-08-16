import 'package:datafire/src/bloc/login_auth_bloc.dart';
import 'package:datafire/src/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key, required this.controller});
  final SidebarXController controller;
  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: widget.controller,
      theme: SidebarXTheme(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(0, 5))
          ], color: canvasColor, borderRadius: BorderRadius.circular(20)),
          textStyle: const TextStyle(color: colorIcon),
          selectedTextStyle: const TextStyle(color: colorIcon),
          itemDecoration: BoxDecoration(border: Border.all(color: canvasColor)),
          selectedItemDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: materialPColor2.withOpacity(0.5)),
              color: materialPColor,
              boxShadow: const [BoxShadow(color: materialPColor, blurRadius: 15)]),
          iconTheme: const IconThemeData(color: unselectColor, size: 20),
          selectedIconTheme: const IconThemeData(color: materialPColor2)),
      extendedTheme: const SidebarXTheme(
          textStyle: TextStyle(fontFamily: 'GoogleSans'),
          width: 200,
          selectedItemTextPadding: EdgeInsets.only(left: 10),
          itemTextPadding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(color: canvasColor, boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 5))
          ]),
          margin: EdgeInsets.only(right: 10)),
      footerDivider: divider,
      headerBuilder: (_, extended) {
        //Cambiar accion de back por otra
        return SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            //inkwell es un animado para los botones, hacerlos mas esteticos
            // checar diseños de botones en material
            child: InkWell(
              focusColor: actionColor,
              highlightColor: actionColor,
              splashColor: accentCanvasColor,
              hoverColor: unselectColor.withOpacity(0.10),
              //cambiar Boton Perfil
              child: IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {},
              ),
            ),
          ),
        );
      },
      //aqui se editan la cantidad de pestañas
      items: [
        SidebarXItem(icon: Icons.home, label: 'Dashboard', onTap: () {}),
        SidebarXItem(
            icon: Icons.assignment,
            label: 'Alta Proyectos',
            onTap: () {
              debugPrint('Alta Proyectos');
            }),
        SidebarXItem(
            icon: Icons.group,
            label: 'Clientes ',
            onTap: () {
              debugPrint('Clientes');
            }),
        SidebarXItem(
            icon: Icons.assignment_ind,
            label: 'Trabajadores',
            onTap: () {
              debugPrint('Trabajadores');
            }),
        SidebarXItem(
            icon: Icons.account_balance,
            label: 'Balance',
            onTap: () {
              debugPrint('Balance');
            }),
        SidebarXItem(
            icon: Icons.local_play_rounded,
            label: 'Nominas',
            onTap: () {
              debugPrint('Nominas');
            }),
        SidebarXItem(
            icon: Icons.verified_user,
            label: 'Users',
            onTap: () {
              debugPrint('Usuarios');
            }),
        SidebarXItem(
            icon: Icons.chat_bubble,
            label: 'FireIA',
            onTap: () {
              debugPrint('chat');
            }),
        SidebarXItem(
          icon: Icons.exit_to_app,
          label: 'Log Out',
          onTap: () async {
            await _showLogoutConfirmationDialog(context);
          },
        ),
      ],
    );
  }
}

_showLogoutConfirmationDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Seguro que quieres cerrar sesión?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el diálogo
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              context.read<LoginBloc>().add(LogoutRequested(context: context));
            },
            child: const Text('Confirmar'),
          ),
        ],
      );
    },
  );
}

_performLogout(BuildContext context) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  } catch (e) {
    print('Error al realizar la navegación: $e');
  }
}
