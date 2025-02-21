import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/todo_model.dart';
import '../presenter/insert_note_presenter.dart';

class InsertNotePage extends StatelessWidget {
  final TodoModel todo;
  InsertNotePage({Key? key, required this.todo}) : super(key: key);

  final InsertNotePresenter c = Get.put(InsertNotePresenter());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    contentController.text = todo.body ?? "";
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              c.title.value = titleController.text;
              c.content.value = contentController.text;
              c.updateNote(todo);
            },
          ),
        ],
      ),
      bottomSheet: Obx(() {
        if (!c.isSaved.value) {
          return SizedBox.shrink();
        }
        return SafeArea(
          child: Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade400),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Catatan berhasil diupdate",
                    style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              onChanged: (value) => c.title.value = value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: "Judul Catatan",
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: contentController,
              onChanged: (value) => c.content.value = value,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Tulis sesuatu...",
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
