import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:projeto_final/helpers/launch_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchPage extends StatefulWidget {
  final Launch launch;

  LaunchPage({this.launch});

  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {

  final _nameController = TextEditingController();
  final _detailsController = TextEditingController();
  final _valorController = TextEditingController();
  final _vencController = TextEditingController();

  final _nameFocus = FocusNode();
  Launch _editedLaunch;
  bool _userEdited = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.launch == null) {
      _editedLaunch = Launch();
    } else {
      _editedLaunch = Launch.fromMap(widget.launch.toMap());

      _nameController.text = _editedLaunch.name;
      _detailsController.text = _editedLaunch.details;
      _valorController.text = _editedLaunch.valor;
      _vencController.text = _editedLaunch.venc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(_editedLaunch.name ?? "Novo Lançamento"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_editedLaunch.name != null && _editedLaunch.name.isNotEmpty){
            Navigator.pop(context, _editedLaunch);
          } else {
            FocusScope.of(context).requestFocus(_nameFocus);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("images/boleto.png")),
              ),
            ),
            TextField(
              controller: _nameController,
              focusNode: _nameFocus,
              decoration: InputDecoration(
                  labelText: "Nome",
                  hintText: "Ex: Conta de luz...Boleto Escolar..."),
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  _editedLaunch.name = text;
                });
              },
            ),
            TextField(
              controller: _detailsController,
              decoration: InputDecoration(
                  labelText: "Detalhes",
                  hintText: "Ex: Conta fixa de luz paga todo mês..."),
              onChanged: (text) {
                _userEdited = true;
                _editedLaunch.details = text;
              },
            ),
            TextField(
              controller: _valorController,
              decoration: InputDecoration(
                  labelText: "Valor", hintText: "Ex: 10.0...250.0"),
              onChanged: (text) {
                _userEdited = true;
                _editedLaunch.valor = text;
              },
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _vencController,
              decoration: InputDecoration(
                  labelText: "Vencimento", hintText: "Ex: 10.05.2019"),
              onChanged: (text) {
                _userEdited = true;
                _editedLaunch.venc = text;
              },
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    ),
    );
  }


 Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Descartar Alterações?"),
          content: Text("Se sair as alterações serão perdidas."),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar"),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Sim"),
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
