import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: StreamBuilder<QuerySnapshot>(
          stream: fireStore.collection('tasks').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text('No tasks to display');
            } else {
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Container(
                    height: 100,
                    margin: const EdgeInsets.only(bottom: 15.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(26, 97, 74, 74),
                            blurRadius: 5.0,
                            offset: Offset(0, 5),
                          )
                        ]),
                    child: ListTile(
                      title: Text(data['taskName']),
                      subtitle: Text(data['taskDesc']),
                      isThreeLine: true,
                    ),
                  );
                }).toList(),
              );
            }
          }),
    );
  }
}
