import 'package:get/get.dart';
import '../base/base_connection.dart';
import '../models/todo_model.dart';

class TodoPresenter extends GetxController {
  var todos = <TodoModel>[].obs;

  var isLoading = false.obs;
  final BaseConnection _connection = BaseConnection();

  var isSearching = false.obs;
  var searchQuery = ''.obs;

  var isDeleted = false.obs;
  var recentlyDeletedTodo = Rxn<TodoModel>();

  List<TodoModel> get filteredTodos {
    if (searchQuery.isEmpty) {
      return todos;
    }
    final q = searchQuery.value.toLowerCase();
    return todos.where((t) => t.title.toLowerCase().contains(q)).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    try {
      isLoading.value = true;
      final r = await _connection.getRequest('/posts');
      if (r.statusCode == 200) {
        List data = r.body;
        todos.assignAll(data.map((e) => TodoModel.fromJson(e)).toList());
      }
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> addTodo(TodoModel todo) async {
    final r = await _connection.postRequest('/posts', todo.toJson());
    if (r.statusCode == 201) {
      var newTodo = TodoModel.fromJson(r.body);
      todos.add(newTodo);
      fetchTodos();
    }
  }

  Future<void> updateTodo(TodoModel todo) async {
    final r = await _connection.putRequest('/posts/${todo.id}', todo.toJson());
    if (r.statusCode == 200) {
      var u = TodoModel.fromJson(r.body);
      int i = todos.indexWhere((e) => e.id == todo.id);
      if (i != -1) {
        todos[i] = u;
      }
    }
  }

  void deleteWithNotification(TodoModel todo) {
    recentlyDeletedTodo.value = todo;
    todos.remove(todo);
    isDeleted.value = true;
  }

  void restoreDeletedTodo() {
    if (recentlyDeletedTodo.value != null) {
      todos.add(recentlyDeletedTodo.value!);
      recentlyDeletedTodo.value = null;
    }
    isDeleted.value = false;
  }

  Future<void> deleteTodo(int id) async {
    final r = await _connection.deleteRequest('/posts/$id');
    if (r.statusCode == 200) {
      todos.removeWhere((e) => e.id == id);
    }
  }
}