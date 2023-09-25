import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateTaskAlertDialog extends StatefulWidget {
  final String taskId, taskName, taskDesc, taskTag, taskStatus;
  const UpdateTaskAlertDialog(
      {super.key,
      required this.taskId,
      required this.taskName,
      required this.taskDesc,
      required this.taskTag, 
      required this.taskStatus});

  @override
  State<UpdateTaskAlertDialog> createState() => _UpdateTaskAlertDialogState();
}

class _UpdateTaskAlertDialogState extends State<UpdateTaskAlertDialog> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescController = TextEditingController();
  final List<String> taskTag = ['Work', 'Shopping', 'Personal'];
  final List<String> taskStatus = ['To Do', 'In Progress', 'Completed'];
  String selectedValue = '';
  String selectedStatus = '';

  @override
  Widget build(BuildContext context) {
    taskNameController.text = widget.taskName;
    taskDescController.text = widget.taskDesc;

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return AlertDialog(
      scrollable: true,
      title: const Text('Update Task'),
      content: SizedBox(
        height: height * 0.55,
        width: width,
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: taskNameController,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  icon: const Icon(Icons.list_sharp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: taskDescController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  icon: const Icon(Icons.message_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: <Widget>[
                  const Icon(Icons.label_important_outline_rounded),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                         horizontal: 20,
                         vertical: 20, 
                        ),
                        
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      isExpanded: true,
                      value: widget.taskTag,
                      items: taskTag
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (String? value) => setState(
                        () {
                          if (value != null) selectedValue = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: <Widget>[
                  const Icon(Icons.query_stats_rounded),
                  const SizedBox(width: 15.0),
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                         horizontal: 20,
                         vertical: 20, 
                        ),
                        
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      isExpanded: true,
                      value: widget.taskStatus,
                      items: taskStatus
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (String? value) => setState(
                        () {
                          if (value != null) selectedStatus = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
          
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final taskName = taskNameController.text;
            final taskDesc = taskDescController.text;
            var taskTag = '';
            selectedValue == ''
                ? taskTag = widget.taskTag
                : taskTag = selectedValue;
            var taskStatus = '';
            selectedStatus == ''
            ? taskStatus = widget.taskStatus: taskStatus = selectedStatus;    
            _updateTasks(taskName, taskDesc, taskTag, taskStatus);
            Navigator.of(context).pop(true);
          },
          child: const Text('Update'),
        ),
      ],
    );
  }

  Future _updateTasks(String taskName, String taskDesc, String taskTag, String taskStatus) async {
    var collection = FirebaseFirestore.instance.collection('tasks');
    collection
        .doc(widget.taskId)
        .update(
            {'taskName': taskName, 'taskDesc': taskDesc, 'taskTag': taskTag, 'taskStatus': taskStatus})
        .then(
          (_) => Fluttertoast.showToast(
              msg: "Task updated successfully",
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
