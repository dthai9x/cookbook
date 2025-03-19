import 'package:flutter/material.dart';

class FishSelectionDialog extends StatelessWidget {
  const FishSelectionDialog({super.key});

  @override
import 'package:flutter/material.dart';

class FishSelectionDialog extends StatefulWidget {
  const FishSelectionDialog({super.key, required this.onFishAdded, required this.currency});

  final Function() onFishAdded;
  final int currency;

  @override
  State<FishSelectionDialog> createState() => _FishSelectionDialogState();
}

class _FishSelectionDialogState extends State<FishSelectionDialog> {
  int fishCost = 50; // Example cost

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select a Fish'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Goldfish - Cost: 50'),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: widget.currency >= fishCost
                ? () {
                    widget.onFishAdded();
                    Navigator.of(context).pop();
                  }
                : null,
            child: Text(widget.currency >= fishCost ? 'Buy' : 'Not Enough Currency'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
