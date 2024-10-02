import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

typedef ActionCallBack = void Function(Key key);
typedef KeyCallBack = void Function(Key key);

const Color primaryColor = Color(0xFF4A4A4A);
const Color keypadColor = Color.fromARGB(255, 34, 153, 34);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TextEditingController textAreaController;

  final Key plusOperator = const Key('+');
  final Key minusOperator = const Key('-');
  final Key multiplicationOperator = const Key('×');
  final Key divisionOperator = const Key('÷');

  final Key dotOperand = const Key('.');
  final Key zeroOperand = const Key('0');
  final Key oneOperand = const Key('1');
  final Key twoOperand = const Key('2');
  final Key threeOperand = const Key('3');
  final Key fourOperand = const Key('4');
  final Key fiveOperand = const Key('5');
  final Key sixOperand = const Key('6');
  final Key sevenOperand = const Key('7');
  final Key eightOperand = const Key('8');
  final Key nineOperand = const Key('9');

  final Key backspaceKey = const Key('backspace');
  final Key clearAllKey = const Key('clearAllKey');
  final Key equalToKey = const Key('equalTo');

  List currentInput = [];
  late double? previousInput = null;
  late Key? currentOperator = null;
  bool savedpreviousInput = false;
  bool isFinalValue = false;

  var height;
  var width;

  @override
  void initState() {
    super.initState();
    textAreaController = TextEditingController();
  }

  void onOperatorPressed(Key actionKey) {
    setState(() {
      if (currentInput.isEmpty) return;

      currentOperator = actionKey;

      if (currentInput.isNotEmpty) {
        previousInput = double.parse(convertListToString(currentInput));
      }
    });
  }

  String convertListToString(List iterator) {
    return iterator.join();
  }

  void onOperandPressed(Key key) {
    if (!savedpreviousInput && previousInput != null) {
      currentInput.clear();
      savedpreviousInput = true;
    }

    if (isFinalValue) {
      if (!identical(dotOperand, key)) {
        currentInput.clear();
      }
      isFinalValue = false;
    }

    setState(() {
      if (identical(sevenOperand, key)) {
        currentInput.add('7');
      } else if (identical(eightOperand, key)) {
        currentInput.add('8');
      } else if (identical(nineOperand, key)) {
        currentInput.add('9');
      } else if (identical(fourOperand, key)) {
        currentInput.add('4');
      } else if (identical(fiveOperand, key)) {
        currentInput.add('5');
      } else if (identical(sixOperand, key)) {
        currentInput.add('6');
      } else if (identical(oneOperand, key)) {
        currentInput.add('1');
      } else if (identical(twoOperand, key)) {
        currentInput.add('2');
      } else if (identical(threeOperand, key)) {
        currentInput.add('3');
      } else if (identical(dotOperand, key)) {
        if (!currentInput.contains('.')) {
          if (currentInput.isEmpty) {
            currentInput.add('0');
          }
          currentInput.add('.');
        }
      } else if (identical(zeroOperand, key)) {
        currentInput.add('0');
      } else if (identical(backspaceKey, key)) {
        if (currentInput.isNotEmpty) {
          currentInput.removeLast();
        }
      } else if (identical(clearAllKey, key)) {
        currentInput.clear();
        previousInput = null;
        savedpreviousInput = false;
        textAreaController.clear();
        currentOperator = null;
      } else if (identical(equalToKey, key)) {
        if (currentInput.isEmpty || previousInput == null) {
          return;
        }
        computeValue();
        savedpreviousInput = false;
        previousInput = null;
      }
      textAreaController.text = convertListToString(currentInput);
    });
  }

  String fixDecimalPrecision(double doubleValue) {
    return doubleValue % 1 == 0 ? doubleValue.toInt().toString() : doubleValue.toStringAsFixed(4);
  }

  void showFinalValue(String val) {
    currentInput.clear();
    currentInput = val.split('');
    currentOperator = null;
    setState(() {
      textAreaController.text = val;
      isFinalValue = true;
    });
  }

  void computeValue() {
    String value;
    Function operation = (double a, double b) => {};

    if (identical(currentOperator, plusOperator)) {
      operation = Math.addition;
    } else if (identical(currentOperator, minusOperator)) {
      operation = Math.subtraction;
    } else if (identical(currentOperator, multiplicationOperator)) {
      operation = Math.multiplication;
    } else if (identical(currentOperator, divisionOperator)) {
      operation = Math.division;
    }

    double doubleValue = double.parse(convertListToString(currentInput));
    value = fixDecimalPrecision(operation(previousInput, doubleValue));
    showFinalValue(value);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.bottomRight,
            width: width,
            height: (height / 100) * 20,
            child: IgnorePointer(
              child: TextField(
                enabled: true,
                autofocus: true,
                controller: textAreaController,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Avenir',
                  color: Colors.white,
                  fontSize: 60.0,
                ),
                decoration: const InputDecoration.collapsed(
                  hintText: '0',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 60.0),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              bindOperatorEvent('+', plusOperator),
              bindOperatorEvent('-', minusOperator),
              bindOperatorEvent('×', multiplicationOperator),
              bindOperatorEvent('÷', divisionOperator)
            ],
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(30.0),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        bindOperandsEvent('7', sevenOperand),
                        bindOperandsEvent('8', eightOperand),
                        bindOperandsEvent('9', nineOperand),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        bindOperandsEvent('4', fourOperand),
                        bindOperandsEvent('5', fiveOperand),
                        bindOperandsEvent('6', sixOperand),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        bindOperandsEvent('1', oneOperand),
                        bindOperandsEvent('2', twoOperand),
                        bindOperandsEvent('3', threeOperand),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        bindOperandsEvent('.', dotOperand),
                        bindOperandsEvent('0', zeroOperand),
                        OperandListener(
                          kkey: backspaceKey,
                          onKeyTap: onOperandPressed,
                          child: const Icon(
                            Icons.backspace,
                            size: 40,
                            color: keypadColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        bindOperandsEvent('AC', clearAllKey),
                        OperandListener(
                          kkey: equalToKey,
                          onKeyTap: onOperandPressed,
                          child: const Text(
                            '=',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 80.0,
                                shadows: [
                                  BoxShadow(
                                      blurRadius: 20.0,
                                      color: primaryColor,
                                      spreadRadius: 30.0)
                                ]),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  OperatorButton bindOperatorEvent(String name, Key key) {
    return OperatorButton(
      key: key,
      actionName: name,
      onTapped: onOperatorPressed,
      enabled: identical(currentOperator, key),
      padding: height > 600 ? const EdgeInsets.all(10.0) : const EdgeInsets.all(0.0),
    );
  }

  OperandListener bindOperandsEvent(String val, Key key) {
    return OperandListener(
      kkey: key,
      onKeyTap: onOperandPressed,
      child: Text(
        val,
        style: const TextStyle(
          color: keypadColor,
          fontFamily: 'Avenir',
          fontSize: 50.0,
        ),
      ),
    );
  }
}

class OperatorButton extends StatelessWidget {
  final Color defaultBackground = const Color.fromARGB(0, 77, 173, 66);
  final Color defaultForeground = const Color.fromRGBO(58, 243, 44, 1);
  final Color changedBackground = const Color.fromRGBO(160, 230, 228, 1);
  final Color changedForeground = Colors.white;

  final String actionName;
  final bool enabled;
  final ActionCallBack onTapped;
  @override
  final Key key;
  final EdgeInsets padding;

  const OperatorButton({
    required this.actionName,
    required this.onTapped,
    required this.enabled,
    required this.key,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: padding,
        color: const Color(0xffF6F6F6),
        child: GestureDetector(
          onTap: () => onTapped(key),
          child: CircleAvatar(
            backgroundColor: enabled ? changedBackground : defaultBackground,
            radius: 30,
            child: Text(
              actionName,
              style: TextStyle(
                color: enabled ? changedForeground : defaultForeground,
                fontSize: 40.0,
                fontFamily: 'Avenir',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OperandListener extends StatelessWidget {
  final Widget child;
  final Key kkey;
  final KeyCallBack onKeyTap;

  const OperandListener({
    super.key,
    required this.child,
    required this.kkey,
    required this.onKeyTap,
  });

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: InkResponse(
          splashColor: primaryColor,
          highlightColor: Colors.white,
          onTap: () => onKeyTap(kkey),
          child: Container(
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}

class Math {
  static double addition(double val1, double val2) {
    return val1 + val2;
  }

  static double subtraction(double val1, double val2) {
    return val1 - val2;
  }

  static double multiplication(double val1, double val2) {
    return val1 * val2;
  }

  static double division(double val1, double val2) {
    return val1 / val2;
  }
}
