class TodoModel {
  final String id;          
  final String title;      
  final String subtitle;   
  final String iconName;    
  final DateTime dateTime;  
  final bool isDone;        

  TodoModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.dateTime,
    required this.isDone,
  });


  factory TodoModel.fromFirestore(Map<String, dynamic> data, String docId) {
    return TodoModel(
      id: docId,
      title: data['title'] ?? '',
      subtitle: data['subtitle'] ?? '',
      iconName: data['iconName'] ?? 'star',
      
      dateTime: (data['dateTime'] as dynamic)?.toDate() ?? DateTime.now(),
      isDone: data['isDone'] ?? false,
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'subtitle': subtitle,
      'iconName': iconName,
      'dateTime': dateTime,   
      'isDone': isDone,
    };
  }
}