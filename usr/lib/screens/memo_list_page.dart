import 'package:flutter/material.dart';
import 'package:couldai_user_app/models/memo.dart';
import 'package:couldai_user_app/screens/memo_detail_page.dart';

class MemoListPage extends StatefulWidget {
  const MemoListPage({super.key});

  @override
  State<MemoListPage> createState() => _MemoListPageState();
}

class _MemoListPageState extends State<MemoListPage> {
  final List<Memo> _memos = [];

  void _addOrUpdateMemo(Memo memo) {
    final index = _memos.indexWhere((element) => element.id == memo.id);
    setState(() {
      if (index != -1) {
        _memos[index] = memo;
      } else {
        _memos.add(memo);
      }
      _memos.sort((a, b) => b.updatedTime.compareTo(a.updatedTime));
    });
  }

  void _deleteMemo(String id) {
    setState(() {
      _memos.removeWhere((element) => element.id == id);
    });
  }

  void _navigateAndEditMemo(BuildContext context, {Memo? memo}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoDetailPage(memo: memo),
      ),
    );

    if (result != null && result is Memo) {
      _addOrUpdateMemo(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memos'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _memos.isEmpty
          ? const Center(
              child: Text('No memos yet. Tap + to add one!'),
            )
          : ListView.builder(
              itemCount: _memos.length,
              itemBuilder: (context, index) {
                final memo = _memos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(memo.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(memo.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: () => _navigateAndEditMemo(context, memo: memo),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Delete Memo'),
                              content: const Text('Are you sure you want to delete this memo?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () {
                                    _deleteMemo(memo.id);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndEditMemo(context),
        tooltip: 'New Memo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
