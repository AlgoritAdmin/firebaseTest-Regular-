import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetest/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List personals = [];

  @override
  void initState() {
    super.initState();
    getPerson();
  }

  void getPerson() async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('Personal');

    QuerySnapshot personal = await collectionReference.get();

    if (personal.docs.isNotEmpty) {
      for (var doc in personal.docs) {
        personals.add(doc.data());
      }
    }
  }

  void putPerson(data) async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('Personal');

    await collectionReference.add(data);
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    getPerson();
    return Scaffold(
      floatingActionButton: GFButton(
        onPressed: (){
          showDialog(context: context, builder: (_) => CustomEventDialog());
        },
        text: "Agregar Personal",
        icon: Icon(Icons.edit, color: Colors.white,),
        shape: GFButtonShape.pills,
        size: 50,
        textStyle: TextStyle(fontSize: 15),
        color: Colors.red,
      ),
      appBar: AppBar(
        title: Text('Personal'),
        centerTitle: true,
        backgroundColor: Colors.red,
        leading: Icon(Icons.arrow_back_ios_new),
      ),
      body: Stack(
        children: [
          fondoApp(),
          _itemsApp(personals)
        ],
      ),
    );
  }

  Widget _itemsApp(List personals){
    return ListView.builder(
      itemCount: personals.length,
      itemBuilder: (context, i) => _crearItem(personals[i])
    );
  }

  Widget _crearItem(personal){
    return Card(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 10,),
                Text('${personal['name']} ${personal['lastname']}', style: TextStyle(fontSize: 20),)
              ],
            ),
            Row(
              children: [
                Icon(Icons.document_scanner_rounded),
                SizedBox(width: 10,),
                Text('${personal['document']}')
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomEventDialog extends StatefulWidget {
  const CustomEventDialog({Key? key}) : super(key: key);

  @override
  CustomEventDialogState createState() => CustomEventDialogState();
}

class CustomEventDialogState extends State<CustomEventDialog> {

  Map<String, dynamic> userEnv = {};

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          Material(
            color: Colors.red,
            child: titleEdicion(context),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                campoEdicion("", "Nombre", 0),
                Container(height: 15),
                campoEdicion("", "Apellido", 1),
                Container(height: 15),
                campoEdicion("", "Documento", 2),
                Container(height: 15),
              ],
            ),
          ),
          Container(height: 20)
        ],
      ),
    ));
  }

  TextField campoEdicion(String text, String label, int t,
      {bool read = false}) {
    return TextField(
      onChanged: (value) {
        switch (t) {
          case 0:
            userEnv["name"] = value;
            break;
          case 1:
            userEnv["lastname"] = value;
            break;
          case 2:
            userEnv["document"] = value;
            break;
          default:
        }
      },
      readOnly: read,
      controller: TextEditingController()..text = text,
      style: TextStyle(fontSize: 18),
      decoration: InputDecoration(
          labelText: label,
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey)),
    );
  }

  SizedBox titleEdicion(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          const Text('Añadir Usuario',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          const Spacer(),
          InkWell(
            splashColor: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              child:
                  const Text('GUARDAR', style: TextStyle(color: Colors.white)),
            ),
            onTap: () {
              putPerson(userEnv);
              Navigator.popAndPushNamed(context, 'home');
            },
          ),
        ],
      ),
    );
  }

  void putPerson(data) async{
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('Personal');

    await collectionReference.add(data);

  }
}

