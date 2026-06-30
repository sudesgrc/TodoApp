import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/todo_model.dart';
import '../widgets/todo_item.dart';
import '../widgets/add_todo_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,

     
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Görev Listem',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Bugün ne yapacaksın?',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
         
          StreamBuilder<List<TodoModel>>(
            stream: service.getTodosStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              final done = snapshot.data!.where((t) => t.isDone).length;
              final total = snapshot.data!.length;
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    '$done/$total',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),


      body: StreamBuilder<List<TodoModel>>(
        stream: service.getTodosStream(),
        builder: (context, snapshot) {

         
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text('Hata: ${snapshot.error}'),
                ],
              ),
            );
          }

         
          final todos = snapshot.data ?? [];
          if (todos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.checklist_rtl_rounded,
                      size: 80, color: Colors.deepPurple.shade200),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz görev yok!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sağ alttaki + butonuna bas ve ekle.',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ],
              ),
            );
          }

         
          return Column(
            children: [
              
              _buildProgressBar(todos),

             
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 100),
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    return TodoItem(todo: todos[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),


      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
         
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, 
            backgroundColor: Colors.transparent,
            builder: (context) => const AddTodoSheet(),
          );
        },
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Yeni Görev'),
      ),
    );
  }

 
  Widget _buildProgressBar(List<TodoModel> todos) {
    final done = todos.where((t) => t.isDone).length;
    final total = todos.length;
    final percent = total == 0 ? 0.0 : done / total;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade700,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tamamlanma Durumu',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                '%${(percent * 100).toInt()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$done görev tamamlandı, ${total - done} görev bekliyor',
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ),
    );
  }
}