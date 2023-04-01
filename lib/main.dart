import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String previousCalculation = '';
  String currentCalculation = '0';

  void updateCalculation(String text) {
    if (currentCalculation == '0') {
      currentCalculation = text;
    } else {
      currentCalculation += text;
    }
    setState(() {});
  }

  void clear() {
    previousCalculation = '';
    currentCalculation = '0';
    setState(() {});
  }

  void delete() {
    if (currentCalculation.length > 1) {
      currentCalculation = currentCalculation.substring(0, currentCalculation.length - 1);
    } else {
      currentCalculation = '0';
    }
    setState(() {});
  }

  void changeSign() {
    try {
      previousCalculation = currentCalculation;
      currentCalculation = (eval(currentCalculation)*-1).toString().replaceAll('.', ',');
    } catch (e) {
      currentCalculation = 'Error';
    }
    setState(() {});
  }

  void evaluate() {
    try {
      previousCalculation = currentCalculation;
      currentCalculation = eval(currentCalculation).toString().replaceAll('.', ',');
    } catch (e) {
      currentCalculation = 'Error';
    }
    setState(() {});
  }

  double eval(String expression) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression.replaceAll(',', '.'));
      ContextModel cm = ContextModel();
      return exp.evaluate(EvaluationType.REAL, cm);
    } catch (e) {
      throw Exception('Invalid Expression');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /*title: Text('Calculator'),
        centerTitle: true,*/
      ),
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          if (orientation == Orientation.portrait) {
            return buildPortraitLayout();
          } else {
            return buildLandscapeLayout();
          }
        },
      ),
    );
  }

  Widget buildRightSide({vertical = true}) {
    return Padding(
      padding: EdgeInsets.all(vertical? 5 : 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Spacer(),
          Text(previousCalculation, style: TextStyle(fontSize: vertical? 48 : 36)),
          const SizedBox(height: 16),
          Text(currentCalculation, style: TextStyle(fontSize: vertical? 96 : 48)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('C', color: Colors.redAccent, onPressed: clear, textColor: Colors.black, vertical: vertical),
              buildButton('±', color: Colors.white60, onPressed: changeSign, textColor: Colors.black, vertical: vertical),
              buildButton('%', color: Colors.white60, onPressed: () => updateCalculation('/100'), textColor: Colors.black, vertical: vertical),
              buildButton('÷', color: Colors.orange, onPressed: () => updateCalculation('/'), vertical: vertical),
            ],
          ),
          SizedBox(height: vertical? 16 : 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('7', onPressed: () => updateCalculation('7'), vertical: vertical),
              buildButton('8', onPressed: () => updateCalculation('8'), vertical: vertical),
              buildButton('9', onPressed: () => updateCalculation('9'), vertical: vertical),
              buildButton('×', color: Colors.orange, onPressed: () => updateCalculation('*'), vertical: vertical),
            ],
          ),
          SizedBox(height: vertical? 16 : 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('4', onPressed: () => updateCalculation('4'), vertical: vertical),
              buildButton('5', onPressed: () => updateCalculation('5'), vertical: vertical),
              buildButton('6', onPressed: () => updateCalculation('6'), vertical: vertical),
              buildButton('-', color: Colors.orange, onPressed: () => updateCalculation('-'), vertical: vertical),
            ],
          ),
          SizedBox(height: vertical? 16 : 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('1', onPressed: () => updateCalculation('1'), vertical: vertical),
              buildButton('2', onPressed: () => updateCalculation('2'), vertical: vertical),
              buildButton('3', onPressed: () => updateCalculation('3'), vertical: vertical),
              buildButton('+', color: Colors.orange, onPressed: () => updateCalculation('+'), vertical: vertical),
            ],
          ),
          SizedBox(height: vertical? 16 : 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('0', onPressed: () => updateCalculation('0'), vertical: vertical, zero: true),
              buildButton(',', onPressed: () => updateCalculation(','), vertical: vertical),
              buildButton('=', color: Colors.orange, onPressed: evaluate, vertical: vertical),
            ],
          ),
          SizedBox(height: vertical? 16 : 4),
        ],
      )
    );
  }

  Widget buildPortraitLayout() {
    return buildRightSide();
  }

  Widget buildLandscapeLayout() {
    return buildRightSide(vertical: false);
  }

  Widget buildButton(String text, {zero= false, vertical = true, Color? color = Colors.black38, void Function()? onPressed, Color? textColor = Colors.white}) {/*
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 48,
        minHeight: 48,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color ?? Theme.of(context).colorScheme.primary,
          onPrimary: Theme.of(context).colorScheme.onPrimary,
          shape: CircleBorder(),
          padding: EdgeInsets.all(24),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(fontSize: 24,color: textColor)),
      ),
    );*/

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onPrimary, backgroundColor: color ?? Theme.of(context).colorScheme.primary,
        shape: zero? RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45),
        ) : const CircleBorder(),
        minimumSize: vertical? zero? const Size(352, 128) : const Size(128, 128) : zero? const Size(150, 64) : const Size (64, 64),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(fontSize: vertical? 36 : 18,color: textColor)),
    );
  }

}
