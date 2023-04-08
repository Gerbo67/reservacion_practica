import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservacion/src/core/models/agenda_model.dart';
import 'package:reservacion/src/ui/utils/configure.dart';
import 'package:reservacion/src/ui/pages/home/home_controller.dart';
import 'package:reservacion/src/ui/utils/responsive.dart';

import '../../widgets/custom_dialogs/delete_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final provider = Provider.of<HomeController>(context);
    List<Agenda> items = provider.agendaItems;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Reserva una cancha de tenis",
            style: TextStyle(
                color: Configure.PRIMARY_BLACK,
                fontWeight: FontWeight.bold,
                fontSize: responsive.wp(5)),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Flexible(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/banner.png'),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50))),
                      width: responsive.wp(100),
                      height: responsive.wp(50),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    sliver: items.isEmpty
                        ? SliverToBoxAdapter(
                            child: SizedBox(
                            height: responsive.wp(50),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "De momento no hay datos disponibles",
                                    style: TextStyle(
                                        color: Configure.PRIMARY_BLACK
                                            .withOpacity(0.7),
                                        fontWeight: FontWeight.bold,
                                        fontSize: responsive.dp(1.5)),
                                  ),
                                ]),
                          ))
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return ListTile(
                                  leading: Chip(
                                    label: Text(
                                      'Cancha ${items[index].nameC}',
                                      style: const TextStyle(
                                          color: Configure.PRIMARY_BLACK),
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //Nombre del reservante
                                      Text(items[index].name,
                                          style: const TextStyle(
                                              color: Configure.PRIMARY_BLACK)),

                                      //Fecha y probalidad de lluvia
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //Fecha
                                          Row(
                                            children: [
                                              const Icon(
                                                  EvaIcons.calendarOutline,
                                                  color:
                                                      Configure.PRIMARY_BLACK),
                                              Text(
                                                  provider
                                                      .date(items[index].date)
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Configure
                                                          .PRIMARY_BLACK)),
                                            ],
                                          ),

                                          //Hora
                                          Row(
                                            children: [
                                              const Icon(EvaIcons.clockOutline,
                                                  color:
                                                      Configure.PRIMARY_BLACK),
                                              Text(
                                                  provider
                                                      .hour(items[index].date)
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: Configure
                                                          .PRIMARY_BLACK)),
                                            ],
                                          ),

                                          //Probabilidad de lluvia
                                          Row(
                                            children: [
                                              const Icon(
                                                  EvaIcons.umbrellaOutline,
                                                  color:
                                                      Configure.PRIMARY_BLACK),
                                              Text(
                                                  items[index].rain == -1.0
                                                      ? 'N/A%'
                                                      : '${items[index].rain}%',
                                                  style: const TextStyle(
                                                      color: Configure
                                                          .PRIMARY_BLACK)),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  onLongPress: () => showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20))),
                                      builder: (_) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextButton(
                                              onPressed: () =>
                                                  dialogDelete(context, () {
                                                    provider.deleteRegister(
                                                        items[index]);
                                                    //Cerrar modal y dialog
                                                    Navigator.popUntil(
                                                        context,
                                                        (route) =>
                                                            route.isFirst);
                                                  }),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    EvaIcons.trash,
                                                    color: Configure.PRIMARY,
                                                    size: responsive.wp(6),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    "Eliminar",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            responsive.wp(4)),
                                                  )
                                                ],
                                              )),
                                        );
                                      }),
                                );
                              },
                              childCount: items.length,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: ElevatedButton(
                  onPressed: () => provider.nextRegister(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(EvaIcons.plusCircleOutline),
                      SizedBox(width: 10),
                      Text(
                        "Agregar una reservación",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
            )
          ],
        ));
  }
}
