import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateful Lab',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  final TextEditingController _controller = TextEditingController();

  Color getColor() {
    if (_counter == 0) return Colors.red;
    if (_counter > 50) return Colors.green;
    return Colors.black;
  }

  void _setValueFromInput() {
    final String raw = _controller.text.trim();
    final int? value = int.tryParse(raw); 

    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid number')),
      );
      return;
    }

    if (value > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Limit Reached!')),
      );
      setState(() {
        _counter = 100; // clamp to 100
      });
      return;
    }

    if (value < 0) {
      setState(() {
        _counter = 0; // clamp to 0
      });
      return;
    }

    setState(() {
      _counter = value;
    });
  }

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Interactive Counter')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              color: Colors.blue.shade100,
              padding: EdgeInsets.all(20),
              child: Text(
                '$_counter',
                style: TextStyle(
                  fontSize: 50.0,
                  color: getColor(),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),

          Slider(
            min: 0,
            max: 100,
            value: _counter.toDouble(),
            onChanged: (double value) {
              setState(() {
                _counter = value.toInt();
              });
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_counter > 0) _counter -= 1;
                  });
                },
                child: Text('-'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (_counter < 100) _counter += 1;
                  });
                },
                child: Text('+'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _counter = 0;
                  });
                },
                child: Text('Reset'),
              ),
            ],
          ),

          SizedBox(height: 25),

          // ✅ Custom increment / set value UI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter value (0–100)',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          SizedBox(height: 10),

          ElevatedButton(
            onPressed: _setValueFromInput,
            child: Text('Set Value'),
          ),
        ],
      ),
    );
  }
}
