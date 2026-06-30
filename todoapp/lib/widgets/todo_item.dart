import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_model.dart';
import '../services/firestore_service.dart';
import '../utils/icon_constants.dart';

class TodoItem extends StatelessWidget {
  final TodoModel todo;

  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return Dismissible(
      
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      confirmDismiss: (direction) async {
       
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Görevi Sil'),
            content: const Text('Bu görevi silmek istediğinize emin misiniz?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Sil', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        service.deleteTodo(todo.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: todo.isDone
                ? Colors.green.shade200
                : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            
            service.toggleDone(todo.id, !todo.isDone);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: todo.isDone ? Colors.green : Colors.transparent,
                    border: Border.all(
                      color: todo.isDone ? Colors.green : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: todo.isDone
                      ? const Icon(Icons.check, color: Colors.white, size: 16)
                      : null,
                ),
                const SizedBox(width: 12),

              
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: todo.isDone
                        ? Colors.grey.shade100
                        : Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    
                    getIconData(todo.iconName),
                    color: todo.isDone ? Colors.grey : Colors.deepPurple,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),

               
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                      Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: todo.isDone ? Colors.grey : Colors.black87,
                         
                          decoration: todo.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: Colors.grey,
                          decorationThickness: 2,
                        ),
                      ),

                     
                      if (todo.subtitle.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          todo.subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: todo.isDone
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 12,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('d MMM yyyy', 'tr_TR').format(todo.dateTime),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

               
                Column(
                  children: [
                    Text(
                      getIconLabel(todo.iconName),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.deepPurple.shade300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}