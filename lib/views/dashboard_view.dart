import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/utilities/delete_task_dialog.dart';
import 'package:taskmanager/utilities/update_task_dialog.dart';

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
                          blurRadius: 5.0,
                          offset: Offset(0, 5),
                        )
                      ]),
                  child: ListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Text(data['taskName']),
                        ),
                        Spacer(),
                        Text(
                          data['taskStatus'],
                          style: TextStyle(
                              fontSize: 12,
                              background: Paint()
                                ..strokeWidth = 15.0
                                ..color = _getStatusColor(data['taskStatus'])
                                ..style = PaintingStyle.stroke
                                ..strokeJoin = StrokeJoin.round),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(data['taskDesc']),
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 'edit',
                            child: const Text('Edit'),
                            onTap: () {
                              String taskId = (data['id']);
                              String taskName = (data['taskName']);
                              String taskDesc = (data['taskDesc']);
                              String taskTag = (data['taskTag']);
                              String taskStatus = (data['taskStatus']);

                              Future.delayed(
                                  const Duration(seconds: 0),
                                  () => showDialog(
                                        context: context,
                                        builder: (context) =>
                                            UpdateTaskAlertDialog(
                                          taskId: taskId,
                                          taskName: taskName,
                                          taskDesc: taskDesc,
                                          taskTag: taskTag,
                                          taskStatus: taskStatus,
                                        ),
                                      ));
                            },
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: const Text('Delete'),
                            onTap: () {
                              String taskId = (data['id']);
                              String taskName = (data['taskName']);

                              Future.delayed(
                                  const Duration(seconds: 0),
                                  () => showDialog(
                                        context: context,
                                        builder: (context) =>
                                            DeleteTaskAlertDialog(
                                          taskId: taskId,
                                          taskName: taskName,
                                        ),
                                      ));
                            },
                          )
                        ];
                      },
                    ),
                    dense: true,
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
    
    
  }
  

  Color _getStatusColor(String taskStatus) {
  if (taskStatus == 'Completed') {
    return Colors.green; // Set the color for 'Completed' status
  } else if (taskStatus == 'In Progress') {
    return Colors.orange; // Set the color for 'In Progress' status
  } else {
    return Colors.red; // Set a default color for other statuses
  }
}


}