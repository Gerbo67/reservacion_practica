import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservacion/src/ui/pages/register/register_controller.dart';
import 'package:select_card/select_card.dart';

import '../../utils/configure.dart';
import '../../utils/responsive.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return ChangeNotifierProvider(
      create: (_) => RegisterController(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            iconSize: 30,
            icon: const Icon(EvaIcons.arrowBackOutline,
                color: Configure.PRIMARY_BLACK, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
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
        body: Consumer<RegisterController>(
          builder: (c, provider, _) {
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(15),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          "Nombre del que reserva",
                          style: TextStyle(
                              color: Configure.PRIMARY_BLACK,
                              fontWeight: FontWeight.bold,
                              fontSize: responsive.dp(2)),
                        ),
                        TextFormField(
                          maxLength: 40,
                          onChanged: (String value) {
                            provider.nameUpdate = value;
                            provider.lengthUpdate = value.length;
                          },
                          decoration: InputDecoration(
                              counterText: '${provider.length}/40'),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(15),
                  sliver: SliverToBoxAdapter(
                    child: CalendarDatePicker(
                      lastDate: DateTime.now().add(const Duration(days: 7)),
                      firstDate: DateTime.now(),
                      initialDate: DateTime.now(),
                      onDateChanged: (DateTime value) async {
                        provider.dateSelect = value;
                        await provider.queryExist();
                        provider.weather();
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(15),
                  sliver: SliverToBoxAdapter(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "¿Cual es la cancha que quiere reservar?",
                        style: TextStyle(
                            color: Configure.PRIMARY_BLACK,
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.dp(2)),
                      ),
                      SelectGroupCard(context,
                          ids: const ['A', 'B', 'C'],
                          titles: const ['Cancha A', 'Cancha B', 'Cancha C'],
                          imageSourceType: ImageSourceType.asset,
                          images: const [
                            'assets/images/cancha.png',
                            'assets/images/cancha.png',
                            'assets/images/cancha.png'
                          ],
                          contents: const [
                            'Monterrey',
                            'Guadalajara',
                            'Querétaro'
                          ],
                          cardBackgroundColor: Colors.white,
                          cardSelectedColor: Colors.green,
                          titleTextColor: Configure.PRIMARY_BLACK,
                          contentTextColor: Colors.black87,
                          onTap: (title, id) async {
                        provider.canchaSelect = id;
                        await provider.queryExist();
                        provider.weather();
                      }),
                    ],
                  )),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(15),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Text(
                          "¿A que hora quiere resevar?",
                          style: TextStyle(
                              color: Configure.PRIMARY_BLACK,
                              fontWeight: FontWeight.bold,
                              fontSize: responsive.dp(2)),
                        ),
                        provider.clocksModel.options.isEmpty
                            ? Text(
                                "Ya no hay horario disponible",
                                style: TextStyle(
                                    color: Configure.PRIMARY_BLACK,
                                    fontWeight: FontWeight.normal,
                                    fontSize: responsive.dp(1.5)),
                              )
                            : AbsorbPointer(
                                absorbing: provider.flagLoadHours,
                                child: DropdownButton<String>(
                                  value: provider.clockSelect,
                                  items: provider.clocksModel.options
                                      .map((String option) {
                                    return DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(option),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    provider.clockSelect = value.toString();
                                    provider.weather();
                                  },
                                ),
                              )
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(15),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(EvaIcons.umbrellaOutline),
                        const SizedBox(height: 15),
                        provider.probabilityText == "-2.0"
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Text("${provider.probabilityText}%")
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(15),
                  sliver: SliverToBoxAdapter(
                    child: AbsorbPointer(
                      absorbing: provider.flagLoadHours,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  provider.flagLoadHours
                                      ? Colors.grey
                                      : Configure.PRIMARY)),
                          onPressed: () async =>
                              await provider.addAgenda(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(EvaIcons.plusCircleOutline),
                              SizedBox(width: 10),
                              Text(
                                "Agregar reservación",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          )),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
