import 'package:flutter/material.dart';
import 'package:projeto_final/helpers/launch_helper.dart';
import 'package:projeto_final/ui/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SaldoPage extends StatefulWidget {
  @override
  _SaldoPageState createState() => _SaldoPageState();
}

class _SaldoPageState extends State<SaldoPage> {
  LaunchHelper helper = LaunchHelper();
  List<Launch> launcher = List();

  @override
  void initState() {
    super.initState();

    _getAllLaunch();
  }


  final _salarioController = TextEditingController;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Início"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Image(image: AssetImage("images/MEP.png")),
            padding: EdgeInsets.only(bottom: 20.0),
          ),
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: TextField(
              //controller: _salarioController,
              decoration: InputDecoration(
                labelText: "SALÁRIO",
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
                prefixText: "R\$",
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.only(top: 20.0),
            child: Column(
              children: <Widget>[
                Text("R\$-${_saldoTotal()}", style: TextStyle(fontSize: 40.0, color: Colors.red),),
                Text("SALDO", style: TextStyle(fontSize: 20.0),),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            color: Colors.amber,
            textColor: Colors.black,
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: const Text(
                "Ver Lançamentos",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  double _saldoTotal() {
    double total = 0;
    for (int i = 0; i < launcher.length; i++) {
      total += double.parse(launcher[i].valor);
    }
    return (total);
  }

  void _getAllLaunch() {
    helper.getAllLaunch().then((list) {
      setState(() {
        launcher = list;
      });
    });
  }
}
