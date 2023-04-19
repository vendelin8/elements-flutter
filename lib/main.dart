import 'dart:async';
import 'dart:math';
import 'element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

const initialPage = 999999;
const jumpDur = 420;
const jumpLimit = 45;
final controller = PageController(initialPage: initialPage);
final now = DateTime.now();
final firstDate = DateTime.utc(100, DateTime.january, 1);
final lastDate = DateTime.utc(3000, DateTime.january, 1);

void main() {
  runApp(const Main());
}

DateTime getCurrentDay(int index) => now.add(Duration(days: index - initialPage));

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), Locale('zh'), Locale('es'), Locale('fr'), Locale('ru'), //
          Locale('pt'), Locale('de'), Locale('tr'), Locale('it'), Locale('pl'),
          Locale('hu'), Locale('ro'), Locale('sl'), Locale('sk'), Locale('bg'),
          Locale('cs'), Locale('sr'), Locale('el'), Locale('ar'), Locale('af'),
          Locale('hr'), Locale('ko'), Locale('vi'), Locale('ca'), Locale('he')
        ],
        title: 'Elements',
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
        home: const Home(),
      );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  DateTime _currentDay = now;

  FutureOr<dynamic> onDateChange(DateTime? value) {
    if (value == null) {
      return null;
    }
    final newPage = initialPage + (value.difference(now).inHours / 24).ceil();
    final cp = controller.page ?? 0;
    if (newPage - cp.floor().abs() > jumpLimit) {
      controller.jumpToPage(newPage);
      return null;
    }
    final ms = (sqrt((cp - newPage.toDouble()).abs()) * jumpDur).round();
    controller.animateToPage(
      newPage,
      duration: Duration(milliseconds: ms),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              onPageChanged: (index) {
                _currentDay = getCurrentDay(index);
                setState(() {});
              },
              itemBuilder: (context, index) => Day(index),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF43A047))),
            onPressed: () => showDatePicker(
              context: context,
              firstDate: firstDate,
              lastDate: lastDate,
              initialDate: _currentDay,
              currentDate: now,
            ).then(onDateChange),
            child: Center(
              child: Text(
                  DateFormat.yMd(Localizations.maybeLocaleOf(context)?.toLanguageTag())
                      .format(_currentDay),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 54, color: Colors.white70)),
            ),
          ),
        ],
      );
}

class Day extends StatelessWidget {
  final int index;
  const Day(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    final dayInt = getDay(getCurrentDay(index));
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[getElementShen(dayInt), getElementQi(dayInt), getElementJing(dayInt)],
    );
  }
}
