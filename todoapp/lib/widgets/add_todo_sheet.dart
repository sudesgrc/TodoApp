import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_model.dart';
import '../services/firestore_service.dart';
import '../utils/icon_constants.dart';

class AddTodoSheet extends StatefulWidget {
  const AddTodoSheet({super.key});

  @override
  State<AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends State<AddTodoSheet> {

  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();

  AppIcon _selectedIcon = kTodoIcons.first;


  DateTime _selectedDate = DateTime.now();


  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('tr', 'TR'), 
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }


  Future<void> _save() async {
    
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen başlık giriniz.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    
    final todo = TodoModel(
      id: '',                            
      title: _titleController.text.trim(),
      subtitle: _subtitleController.text.trim(),
      iconName: _selectedIcon.name,      
      dateTime: _selectedDate,
      isDone: false,                  
    );

    
    await FirestoreService().addTodo(todo);

    setState(() => _isSaving = false);

    if (mounted) Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
     
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

          
            Text(
              'Yeni Görev Ekle',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

         
            DropdownButtonFormField<AppIcon>(
              value: _selectedIcon,
              decoration: InputDecoration(
                labelText: 'İkon Seçiniz',
                prefixIcon: Icon(_selectedIcon.icon, color: Colors.deepPurple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              items: kTodoIcons.map((appIcon) {
                return DropdownMenuItem<AppIcon>(
                  value: appIcon,
                  child: Row(
                    children: [
                      Icon(appIcon.icon, size: 20),
                      const SizedBox(width: 10),
                      Text(appIcon.label),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (AppIcon? newIcon) {
                if (newIcon != null) {
                  setState(() => _selectedIcon = newIcon);
                }
              },
            ),
            const SizedBox(height: 14),

            
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Başlık *',
                hintText: 'Görev başlığı giriniz',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 14),

           
            TextField(
              controller: _subtitleController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Alt Başlık (İçerik)',
                hintText: 'Detay bilgisi giriniz',
                prefixIcon: const Icon(Icons.notes),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 14),

           
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Tarih',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                child: Text(
                  
                  DateFormat('d MMMM yyyy', 'tr_TR').format(_selectedDate),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 24),

          
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_rounded),
                label: Text(_isSaving ? 'Kaydediliyor...' : 'Kaydet'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}