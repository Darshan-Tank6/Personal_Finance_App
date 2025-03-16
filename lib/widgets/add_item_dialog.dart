import 'package:flutter/material.dart';

class AddItemDialog extends StatelessWidget {
  final String title;
  final Function(String) onAdd;

  const AddItemDialog({required this.title, required this.onAdd, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return AlertDialog(
      title: Text('Add $title'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: "Enter new $title",
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String newItem = _controller.text.trim();
            if (newItem.isNotEmpty) {
              onAdd(newItem);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
