import 'package:get/get.dart';
import '../base/base_connection.dart';
import '../models/todo_model.dart';

class InsertNotePresenter extends GetxController {
  var title = ''.obs;
  var content = ''.obs;
  var isSaved = false.obs;
  final BaseConnection _connection = BaseConnection();

  void updateNote(TodoModel todo) async {
    if (title.value.isEmpty) {
      Get.snackbar('Error', 'Title is required');
      return;
    }
    var updatedNote = TodoModel(
      userId: todo.userId,
      id: todo.id,
      title: title.value,
      body: content.value,
      completed: todo.completed,
    );
    final response = await _connection.putRequest('/posts/${todo.id}', updatedNote.toJson());
    if (response.statusCode == 200) {
      isSaved.value = true;
      Future.delayed(Duration(seconds: 3), () {
        isSaved.value = false;
      });
    } else {
      Get.snackbar('Error', 'Failed to update note');
    }
  }
}
