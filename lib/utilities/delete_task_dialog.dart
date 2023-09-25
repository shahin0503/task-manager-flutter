import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeleteTaskAlertDialog extends StatefulWidget {
  final String taskId, taskName;
  const DeleteTaskAlertDialog({super.key, required this.taskId, required this.taskName});

  @override
  State<DeleteTaskAlertDialog> createState() => _DeleteTaskAlertDialogState();
}

class _DeleteTaskAlertDialogState extends State<DeleteTaskAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Delete Task'),
      content: SizedBox(
        child: Form(
          child: Column(
            children: <Widget>[
              const Text('Are you sure you want to delete this task?'),
              const SizedBox(height: 15,),
              Text(
                widget.taskName.toString(),
                style:  TextStyle (fontWeight: FontWeight.bold),
              )
            ],
          ),
        )
        ),
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.of(context).pop(false);
          }, 
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
          child: const Text('Cancel')),
          ElevatedButton(onPressed: (){
            _deleteTasks();
            Navigator.of(context).pop(true);

          },
           child: const Text('Delete')),
        ],
    );
  }


Future _deleteTasks() async {
    var collection = FirebaseFirestore.instance.collection('tasks');
    collection
        .doc(widget.taskId)
        .delete()
        .then(
          (_) => Fluttertoast.showToast(
              msg: "Task deleted successfully",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 14.0),
        )
        .catchError(
          (error) => Fluttertoast.showToast(
              msg: "Failed: $error",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 14.0),
        );
  }
}