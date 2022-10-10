import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter FireBase CRUD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final nameUser = TextEditingController();
  final ageUser = TextEditingController();

  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      nameUser.text = documentSnapshot['name'];
      ageUser.text = documentSnapshot['age'].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext contxt) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(contxt).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameUser,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: ageUser,
                  decoration: const InputDecoration(labelText: 'Age'),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String name = nameUser.text;
                      final int age = int.parse(ageUser.text);
                      if (age != null) {
                        await _users
                            .doc(documentSnapshot!.id)
                            .update({"name": name, "age": age});
                        nameUser.text = "";
                        ageUser.text = "";
                      }
                    },
                    child: Text('Update'))
              ],
            ),
          );
        });
  }

  Future<void> _create() async {
    nameUser.text = "";
    ageUser.text = "";
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext contxt) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(contxt).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameUser,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: ageUser,
                  decoration: const InputDecoration(labelText: 'Age'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      final String name = nameUser.text;
                      final int age = int.parse(ageUser.text);
                      if (age != null) {
                        await _users.add({"name": name, "age": age});
                        nameUser.text = "";
                        ageUser.text = "";
                      }
                    },
                    child: Text('Add'))
              ],
            ),
          );
        });
  }

  Future<void> _delete([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      nameUser.text = documentSnapshot['name'];
      ageUser.text = documentSnapshot['age'].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlatButton(
                onPressed: () async {
                  await _users.doc(documentSnapshot!.id).delete();
                  Navigator.pop(context);
                  nameUser.text = "";
                  ageUser.text = "";
                },
                child: Text("Yes"),
                color: Colors.red,
              ),
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text("No"),
                color: Colors.blue,
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot docsnap = snapshot.data!.docs[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(docsnap['name']),
                      subtitle: Text(docsnap['age'].toString()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  _update(docsnap);
                                },
                                icon: Icon((Icons.edit))),
                            IconButton(
                                onPressed: () {
                                  _delete(docsnap);
                                },
                                icon: Icon((Icons.delete)))
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _create();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
