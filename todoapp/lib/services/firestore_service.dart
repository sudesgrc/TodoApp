import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_model.dart';

class FirestoreService {
 
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final String _collection = 'todos';


  Stream<List<TodoModel>> getTodosStream() {
    return _db
        .collection(_collection)
        .orderBy('dateTime', descending: false) 
        .snapshots()                            
        .map((snapshot) {
          
          return snapshot.docs.map((doc) {
            return TodoModel.fromFirestore(
              doc.data(),  
              doc.id,     
            );
          }).toList();
        });
  }


  Future<void> addTodo(TodoModel todo) async {
    await _db.collection(_collection).add(todo.toFirestore());
  }


  Future<void> toggleDone(String docId, bool isDone) async {
    await _db.collection(_collection).doc(docId).update({
      'isDone': isDone,
    });
  }


  Future<void> deleteTodo(String docId) async {
    await _db.collection(_collection).doc(docId).delete();
  }
}