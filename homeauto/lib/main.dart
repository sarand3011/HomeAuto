import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:alan_voice/alan_voice.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Auto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = FirebaseDatabase.instance.reference();
  Map<String, bool> hasPressed = <String, bool>{"s1": false, "s2": false};
  _MyHomePageState() {
    AlanVoice.addButton(
        "cf455a78856f9efaa33d578be5d8b2972e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);
    AlanVoice.onCommand.add((command) {
      debugPrint("got new command ${command.toString()}");
    });
  }
  void setButtonColor() {
    databaseReference.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
      List<String> k = ["s1", "s2"];
      for (String i in k) {
        setState(() {
          this.hasPressed[i] = snapshot.value[i] == 0;
        });
        print(snapshot.value[i]);
      }
    });
  }

  void setColor(String bulb) {
    databaseReference.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
      List<String> k = ["s1", "s2"];
      for (String i in k) {
        if (i == bulb) {
          setState(() {
            this.hasPressed[i] = snapshot.value[i] == 1;
          });
          print(snapshot.value[i]);
        }
      }
    });
  }

  void createRecord(String bulb) {
    databaseReference.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
      databaseReference.child(bulb).set((snapshot.value[bulb] == 0) ? 1 : 0);
    });
  }

  @override
  void initState() {
    super.initState();
    setButtonColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Auto"),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElevatedButton(
            child: Text('Tube Light'),
            onPressed: () {
              createRecord("s1");
              setColor("s1");
              setState(() {
                hasPressed["s1"] = !hasPressed["s1"];
              });
            },
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(
                hasPressed["s1"] ? Colors.green : Colors.red,
              ),
            ),
          ),
          ElevatedButton(
            child: Text('Night Lamp'),
            onPressed: () {
              createRecord("s2");
              setColor("s2");
              setState(() {
                hasPressed["s2"] = !hasPressed["s2"];
              });
            },
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all<Color>(
                hasPressed["s2"] ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      )), //center
    );
  }
}
