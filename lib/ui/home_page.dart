import 'package:flutter/material.dart';
import 'package:projeto_final/helpers/launch_helper.dart';
import 'package:projeto_final/ui/launch_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LaunchHelper helper = LaunchHelper();
  List<Launch> launcher = List();

  @override
  void initState() {
    super.initState();

    _getAllLaunch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lançamentos   Total: R\$${_saldoTotal()}", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showLaunchPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: launcher.length,
        itemBuilder: (context, index) {
          return _launchCard(context, index);
        },
      ),
    );
  }

  double _saldoTotal() {
    double total = 0;
    for (int i = 0; i < launcher.length; i++) {
      total += double.parse(launcher[i].valor);
    }
    return (total);
  }

  Widget _launchCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage("images/boleto.png")),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      launcher[index].name ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      launcher[index].details ?? "",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      "R\$${launcher[index].valor}",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatButton(
                      child: Text("Apagar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0)),
                      onPressed: () {
                        helper.deleteLaunch(launcher[index].id);
                        setState(() {
                          launcher.removeAt(index);
                          Navigator.pop(context);
                        });
                      },
                    ),
                    FlatButton(
                      child: Text("Editar",
                          style:
                              TextStyle(color: Colors.black, fontSize: 20.0)),
                      onPressed: () {
                        Navigator.pop(context);
                        _showLaunchPage(launch: launcher[index]);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showLaunchPage({Launch launch}) async {
    final recLaunch = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LaunchPage(
                  launch: launch,
                )));
    if (recLaunch != null) {
      if (launch != null) {
        await helper.updateLaunch(recLaunch);
        _getAllLaunch();
      } else {
        await helper.saveLaunch(recLaunch);
      }
      _getAllLaunch();
    }
  }

  void _getAllLaunch() {
    helper.getAllLaunch().then((list) {
      setState(() {
        launcher = list;
      });
    });
  }
}
