import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../utils/configure.dart';
import '../../utils/responsive.dart';

dialogDelete(BuildContext context, Function()? onTap) {
  return showDialog(
      context: context,
      builder: (context) {
        return DialogDelete(onTap: onTap);
      });
}

class DialogDelete extends StatelessWidget {
  const DialogDelete({Key? key, required this.onTap}) : super(key: key);
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return SimpleDialog(
      backgroundColor: Configure.WHITE,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      children: [
        Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context, false),
                child: const Icon(EvaIcons.closeCircle),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "¿Seguro que quieres eliminar el elemento?",
                    style: TextStyle(
                        color: Configure.SECONDARY_BLACK,
                        fontWeight: FontWeight.bold,
                        fontSize: responsive.wp(4)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: onTap,
                          child: Text(
                            "Si, estoy seguro",
                            style: TextStyle(fontSize: responsive.wp(3.5)),
                          )),
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "No, quiero cancelar",
                            style: TextStyle(fontSize: responsive.wp(3.5)),
                          ))
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
