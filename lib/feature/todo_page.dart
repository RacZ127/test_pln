import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/todo_model.dart';
import '../presenter/todo_presenter.dart';
import 'insert_note_page.dart';

class TodoPage extends StatelessWidget {
  TodoPage({Key? key}) : super(key: key);

  final TodoPresenter controller = Get.put(TodoPresenter());
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (!controller.isSearching.value) {
              Get.back();
            } else {
              controller.isSearching.value = false;
              controller.searchQuery.value = '';
              searchController.clear();
            }
          },
        ),
        title: Obx(() {
          if (!controller.isSearching.value) {
            return const Text(
              "Catatan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            );
          } else {
            return Container(
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: TextField(
                controller: searchController,
                autofocus: true,
                onChanged: (value) {
                  controller.searchQuery.value = value;
                  print("Search query: ${controller.searchQuery.value}");
                },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  hintText: "Cari catatan",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      searchController.clear();
                      controller.searchQuery.value = '';
                      controller.isSearching.value = false;
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black54),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            );
          }
        }),
        actions: [
          Obx(() {
            return IconButton(
              icon: !controller.isSearching.value ? const Icon(Icons.search) : const SizedBox.shrink(),
              onPressed: () {
                if (!controller.isSearching.value) {
                  controller.isSearching.value = true;
                }
              },
            );
          }),
        ],
      ),
      bottomSheet: Obx(() {
        if (!controller.isDeleted.value) {
          return const SizedBox.shrink();
        }
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade400),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Catatan berhasil dihapus",
                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.restoreDeletedTodo();
                  },
                  child: Text(
                    "Batal",
                    style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = controller.filteredTodos;
        if (data.isEmpty) {
          return const Center(
            child: Text(
              "Catatan tidak ditemukan\nCoba ubah kalimat pencarian.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchTodos,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, i) {
              final todo = data[i];
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                background: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.delete, color: Colors.red.shade400),
                ),
                onDismissed: (_) {
                  controller.deleteWithNotification(todo);
                },
                child: GestureDetector(
                  onTap: () async {
                    await Get.to(() => InsertNotePage(todo: todo));
                    controller.fetchTodos();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          todo.body ?? "",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "19 Februari 2025",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(38)),
        onPressed: () async {
          await Get.to(() => InsertNotePage(todo: TodoModel(userId: 1, id: null, title: "", body: "", completed: false)));
          controller.fetchTodos();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
