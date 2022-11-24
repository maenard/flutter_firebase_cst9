import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_cst9/firebaseadd.dart';
import 'package:flutter_firebase_cst9/firebaseupdate.dart';
import 'package:flutter_firebase_cst9/user.dart';

class FirebaseRead extends StatefulWidget {
  const FirebaseRead({super.key});

  @override
  State<FirebaseRead> createState() => _FirebaseReadState();
}

class _FirebaseReadState extends State<FirebaseRead> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View All Accounts'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FirebaseAdd(),
                ),
              );
            },
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
      body: StreamBuilder<List<User>>(
        stream: readUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final users = snapshot.data!;

            return ListView(
              children: users.map(buildUser).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget buildUser(User user) => ListTile(
        leading: const Icon(
          Icons.account_circle_rounded,
          size: 40,
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        dense: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FirebaseUpdate(user: user),
                    ),
                  );
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  _showActionSheet(context, user.id);
                },
                icon: const Icon(Icons.delete)),
          ],
        ),
        onTap: () {},
      );
  void _showActionSheet(BuildContext context, String id) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Confirmation'),
        message: const Text(
            'Are you sure you want to delete this user? Doing this will not undo any changes.'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              deleteUser(id);
            },
            child: const Text('Continue'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Stream<List<User>> readUsers() =>
      FirebaseFirestore.instance.collection('Users').snapshots().map(
            (snapshot) => snapshot.docs
                .map(
                  (doc) => User.fromJson(
                    doc.data(),
                  ),
                )
                .toList(),
          );

  deleteUser(String id) {
    final docUser = FirebaseFirestore.instance.collection('Users').doc(id);
    docUser.delete();
    Navigator.pop(context);
  }
}
