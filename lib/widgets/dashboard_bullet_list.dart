import 'package:flutter/material.dart';

class DashboardBulletList extends StatelessWidget {
  const DashboardBulletList({
    super.key,
    required this.items,
  });

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == items.length - 1 ? 0 : 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Icon(Icons.circle, size: 8),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(items[i]),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
