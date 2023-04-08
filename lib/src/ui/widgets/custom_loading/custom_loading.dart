import 'package:flutter/material.dart';
import '../../utils/configure.dart';

class CustomLoading extends StatefulWidget {
  const CustomLoading({Key? key}) : super(key: key);

  @override
  CustomLoadingState createState() => CustomLoadingState();
}

class CustomLoadingState extends State<CustomLoading>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late Animation<double> _animation1;

  late AnimationController _controller2;
  late Animation<double> _animation2;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation1 = Tween<double>(begin: .0, end: .5)
        .animate(CurvedAnimation(parent: _controller1, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller1.reverse();
          _controller2.forward();
        } else if (status == AnimationStatus.dismissed) {
          _controller1.forward();
        }
      });

    _controller2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation2 = Tween<double>(begin: .0, end: .5)
        .animate(CurvedAnimation(parent: _controller2, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller2.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller2.forward();
        }
      });

    _controller1.forward();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Material(
        color: Colors.black26,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white24,
          child: Center(
            child: SizedBox(
              height: 70,
              width: 70,
              child: CustomPaint(
                painter: DotsPainter(_animation1.value, _animation2.value),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DotsPainter extends CustomPainter {
  final double radius_1;
  final double radius_2;

  DotsPainter(this.radius_1, this.radius_2);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circle_1 = Paint()..color = const Color(0xffffffff);

    Paint circle_2 = Paint()..color = Configure.PRIMARY;

    canvas.drawCircle(Offset(size.width * .5, size.height * .5),
        size.width * radius_1, circle_1);

    canvas.drawCircle(Offset(size.width * .5, size.height * .5),
        size.width * radius_2, circle_2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
