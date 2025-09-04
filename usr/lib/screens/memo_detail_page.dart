import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/memo.dart';

class MemoDetailPage extends StatefulWidget {
  final Memo? memo;

  const MemoDetailPage({super.key, this.memo});

  @override
  State<MemoDetailPage> createState() => _MemoDetailPageState();
}

class _MemoDetailPageState extends State<MemoDetailPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  late bool _isNewMemo;

  @override
  void initState() {
    super.initState();
    _isNewMemo = widget.memo == null;
    if (!_isNewMemo) {
      _titleController.text = widget.memo!.title;
      _contentController.text = widget.memo!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveMemo() {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) {
      // Don't save empty memo
      Navigator.pop(context);
      return;
    }

    final memo = Memo(
      id: _isNewMemo ? DateTime.now().millisecondsSinceEpoch.toString() : widget.memo!.id,
      title: _titleController.text.isNotEmpty ? _titleController.text : 'Untitled Memo',
      content: _contentController.text,
      updatedTime: DateTime.now(),
    );
    Navigator.pop(context, memo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNewMemo ? 'New Memo' : 'Edit Memo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveMemo,
            tooltip: 'Save Memo',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Content',
                  border: InputBorder.none,
                ),
                maxLines: null, // Allows for multiline input
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
