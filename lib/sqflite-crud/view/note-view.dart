import 'package:flutter/material.dart';
import 'package:module2programs/sqflite-crud/controller/database_helper.dart';
import '../model/note.dart';

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Note> _notes = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Note? _selectedNote; // Variable to hold the note being edited

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  void _fetchNotes() async {
    _notes = await _dbHelper.getNotes();
    setState(() {});
  }

  void _addOrUpdateNote() async {
    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
      if (_selectedNote == null) {
        // Add new note
        await _dbHelper.insertNote(Note(
          title: _titleController.text,
          content: _contentController.text,
        ));
      } else {
        // Update existing note
        _selectedNote!.title = _titleController.text;
        _selectedNote!.content = _contentController.text;
        await _dbHelper.updateNote(_selectedNote!);
        _selectedNote = null; // Clear selection after updating
      }
      _titleController.clear();
      _contentController.clear();
      _fetchNotes();
    }
  }

  void _editNote(Note note) {
    _selectedNote = note;
    _titleController.text = note.title;
    _contentController.text = note.content;
  }

  void _deleteNote(int id) async {
    await _dbHelper.deleteNote(id);
    _fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notes')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editNote(note), // Populate form for editing
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteNote(note.id!),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(hintText: 'Title'),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    decoration: InputDecoration(hintText: 'Content'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: _addOrUpdateNote, // Add or update based on selection
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
