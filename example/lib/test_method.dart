import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TestClassMethod extends StatefulWidget {
  final String description;
  final dynamic Function() execution;
  const TestClassMethod({
    Key? key,
    required this.description,
    required this.execution,
  }) : super(key: key);

  @override
  State<TestClassMethod> createState() => _TestClassMethodState();
}

class _TestClassMethodState extends State<TestClassMethod> {
  String _result = "";

  @override
  void initState() {
    super.initState();
  }

  void _execLogic() {
    dynamic resultExecution;
    try {
      resultExecution = widget.execution();
    } catch (e) {
      resultExecution = "Error: $e";
    }
    setState(() {
      _result = resultExecution.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 75,
                  child: Text(
                    widget.description,
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: OutlinedButton(
                    onPressed: _execLogic,
                    child: const Text("execute"),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Expanded(flex: 15, child: Text('Result:')),
              Expanded(
                flex: 85,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    color: Colors.white,
                    child: Text(
                      _result.substring(
                          0, _result.length > 50 ? 50 : _result.length),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}
