import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var usersRef = FirebaseFirestore.instance.collection('users');

    //
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran Learner'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          //

          // add
          // var docId = DateTime.now().microsecondsSinceEpoch;
          // usersRef.doc(docId.toString()).set(
          //   {
          //     'name': 'Mim',
          //     'email': '@',
          //   },
          // ).then((value) {
          //   ScaffoldMessenger.of(context)
          //       .showSnackBar(const SnackBar(content: Text('Successful')));
          // });

          //update
          // var docId = '1716492666860621';
          // users.doc(docId).update({
          //   'name': "Md Reyad",
          //   "email": "asifreyad@gmail.com",
          // });

          // await users.doc(docId).delete();
        },
        label: const Text('Add User'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: usersRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('Some thing wrong!'));
            }

            var docs = snapshot.data!.docs;
            if (docs.isEmpty) {
              return const Center(child: Text('No data data!'));
            }

            //
            return ListView.separated(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var doc = docs[index];
                var name = doc.get('name');
                var email = doc.get('email');

                //
                return Card(
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    title: Text(name),
                    subtitle: Text(email),
                    trailing: IconButton(
                        onPressed: () {
                          //del
                          var docID = doc.id;
                          usersRef.doc(docID).delete().whenComplete(() {
                            //
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Deleted!')));
                          });
                        },
                        icon: const Icon(Icons.delete)),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              padding: const EdgeInsets.all(16),
            );
          }),
    );
  }
}
