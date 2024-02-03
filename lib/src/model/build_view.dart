import 'package:flutter/material.dart';
import '../widgets/colors.dart';

GridView buildView(Size size, ThemeData theme, List<dynamic> list) {
  return GridView.builder(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: size.width > 800
            ? size.width > 900
                ? 2
                : 2
            : 1,
        childAspectRatio: size.width > 800
            ? size.width > 900
                ? size.width / 500
                : size.width / 350
            : size.width / 255,
        crossAxisSpacing: 25,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (_, int data) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: canvasColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey, blurRadius: 5, offset: Offset(0, 5))
              ]),
          child: InkWell(
            hoverColor: accentCanvasColor,
            onTap: () {
              debugPrint('Hola!');
            },
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Text(
                        'ID Socio:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        '${list[data].socioId}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Nombre:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        '${list[data].name}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Fecha:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        '${list[data].dateOrder!.day}/0${list[data].dateOrder!.month}/${list[data].dateOrder!.year} ',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Monto Pagado:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        '${list[data].montoPagado}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Cambio:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        '${list[data].cambio!.toStringAsFixed(1)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      )
                    ],
                  )
                ]),
          ),
        );
      });
}
