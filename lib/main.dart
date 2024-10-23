import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _input = '';
  String _result = '';

  void _onButtonPressed(String value) {
    if (value == '=') {
      _calculateResult();
    } else if (value == 'C') {
      _clearInput();
    } else {
      _addToInput(value);
    }
  }

  void _addToInput(String value) {
    if (_input.isEmpty &&
        (value == '+' ||
            value == '-' ||
            value == '*' ||
            value == '/' ||
            value == '^')) return;
    if (_input.isNotEmpty &&
        '/*+-^'.contains(_input[_input.length - 1]) &&
        '/*+-^'.contains(value)) return;

    setState(() {
      _input += value;
    });
  }

  void _clearInput() {
    setState(() {
      _input = '';
      _result = '';
    });
  }

  void _calculateResult() {
    try {
      double result = _evaluateExpression(_input);
      setState(() {
        _result = result.toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Ошибка';
      });
    }
  }

  double _evaluateExpression(String expression) {
    List<String> tokens = expression.split(RegExp(r'(?<=[-+*/^])|(?=[-+*/^])'));
    List<double> numbers = [];
    List<String> operators = [];

    for (String token in tokens) {
      token = token.trim();
      if (token.isEmpty) continue;

      if (double.tryParse(token) != null) {
        numbers.add(double.parse(token));
      } else if (['+', '-', '*', '/', '^'].contains(token)) {
        operators.add(token);
      } else {
        throw FormatException('Недопустимый символ: $token');
      }
    }

    double result = numbers[0];
    for (int i = 0; i < operators.length; i++) {
      String operator = operators[i];
      double nextNumber = numbers[i + 1];

      if (operator == '/' && nextNumber == 0) {
        throw FormatException('Ошибка.');
      }

      result = _performOperation(result, nextNumber, operator);
    }

    return result;
  }

  double _performOperation(double a, double b, String operator) {
    switch (operator) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '*':
        return a * b;
      case '/':
        return a / b;
      case '^':
        return (pow(a, b) as double);
      default:
        throw FormatException('Недопустимый оператор: $operator');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Калькулятор')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(_input, style: TextStyle(fontSize: 24, color: Colors.white)),
            SizedBox(height: 10),
            Text(_result,
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 1.0,
                children: [
                  _buildButton("7", Colors.grey),
                  _buildButton('8', Colors.grey),
                  _buildButton('9', Colors.grey),
                  _buildButton('/', Colors.orange),
                  _buildButton('4', Colors.grey),
                  _buildButton('5', Colors.grey),
                  _buildButton('6', Colors.grey),
                  _buildButton('*', Colors.orange),
                  _buildButton('1', Colors.grey),
                  _buildButton('2', Colors.grey),
                  _buildButton('3', Colors.grey),
                  _buildButton('-', Colors.orange),
                  _buildButton('0', Colors.grey),
                  _buildButton('C', Color.fromARGB(255, 67, 67, 67)),
                  _buildButton('+', Colors.orange),
                  _buildButton('^', Colors.orange),
                  _buildButton('', Colors.black),
                  _buildButton('', Colors.black),
                  _buildButton('', Colors.black),
                  _buildButton('=', Colors.orange),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () => _onButtonPressed(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(60, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(text, style: TextStyle(fontSize: 24, color: Colors.black)),
    );
  }
}
