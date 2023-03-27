import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
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

  void evaluate() {
    try {
      previousCalculation = currentCalculation;
      currentCalculation = eval(currentCalculation).toString();
    } catch (e) {
      currentCalculation = 'Error';
    }
    setState(() {});
  }

  double eval(String expression) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);
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
        title: Text('Calculator'),
        centerTitle: true,
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

  Widget buildPortraitLayout() {
    return Padding(
        padding: EdgeInsets.all(16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
    Spacer(),
    Text(previousCalculation, style: TextStyle(fontSize: 24)),
    SizedBox(height: 16),
    Text(currentCalculation, style: TextStyle(fontSize: 48)),
    SizedBox(height: 16),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    buildButton('C', color: Colors.redAccent, onPressed: clear),
    buildButton('⌫', color: Colors.grey, onPressed: delete),
    buildButton('%', color: Colors.grey, onPressed: () => updateCalculation('/100')),
    buildButton('÷', color: Colors.blue, onPressed: () => updateCalculation('/')),
    ],
    ),
    SizedBox(height: 16),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    buildButton('7', onPressed: () => updateCalculation('7')),
    buildButton('8', onPressed: () => updateCalculation('8')),
    buildButton('9', onPressed: () => updateCalculation('9')),
    buildButton('×', color: Colors.blue, onPressed: () => updateCalculation('*')),
    ],
    ),
    SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButton('4', onPressed: () => updateCalculation('4')),
          buildButton('5', onPressed: () => updateCalculation('5')),
          buildButton('6', onPressed: () => updateCalculation('6')),
          buildButton('-', color: Colors.blue, onPressed: () => updateCalculation('-')),
        ],
      ),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButton('1', onPressed: () => updateCalculation('1')),
          buildButton('2', onPressed: () => updateCalculation('2')),
          buildButton('3', onPressed: () => updateCalculation('3')),
          buildButton('+', color: Colors.blue, onPressed: () => updateCalculation('+')),
        ],
      ),
      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButton('±', onPressed: () => updateCalculation('-$currentCalculation')),
          buildButton('0', onPressed: () => updateCalculation('0')),
          buildButton('.', onPressed: () => updateCalculation('.')),
          buildButton('=', color: Colors.blue, onPressed: evaluate),
        ],
      ),
      Spacer(),
    ],
    ),
    );
  }

  Widget buildLandscapeLayout() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(previousCalculation, style: TextStyle(fontSize: 24)),
              buildButton('C', color: Colors.redAccent, onPressed: clear),
            ],
          ),
          SizedBox(height: 16),
          Text(currentCalculation, style: TextStyle(fontSize: 48)),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton('⌫', color: Colors.grey, onPressed: delete),
              buildButton('%', color: Colors.grey, onPressed: () => updateCalculation('/100')),
              buildButton('÷', color: Colors.blue, onPressed: () => updateCalculation('/')),
              buildButton('×', color: Colors.blue, onPressed: () => updateCalculation('*')),
              buildButton('-', color: Colors.blue, onPressed: () => updateCalculation('-')),
              buildButton('+', color: Colors.blue, onPressed: () => updateCalculation('+')),
              buildButton('=', color: Colors.blue, onPressed: evaluate),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget buildButton(String text, {Color? color, void Function()? onPressed}) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 48,
        minHeight: 48,
        maxWidth: double.infinity,
        maxHeight: double.infinity,
      ),
      child: ElevatedButton(
        child: Text(text, style: TextStyle(fontSize: 24)),
        style: ElevatedButton.styleFrom(
          primary: color ?? Theme.of(context).colorScheme.primary,
          onPrimary: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: onPressed,
      ),
    );
  }

}
