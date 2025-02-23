import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ExpandableContainer extends StatefulWidget {
  final String content;

  const ExpandableContainer({super.key, required this.content});

  @override
  _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          SizedBox(
            height: _isExpanded ? null : 100,
            child: Html(
              data: '<span style="font-size: 12.5px;">${widget.content}</span>',
            ),
          ),
          if (!_isExpanded)
            TextButton(
              onPressed: () {
                setState(() {
                  _isExpanded = true;
                });
              },
              child: const Text('Mở rộng'),
            ),
          Visibility(
            visible: _isExpanded,
            child: const Column(
              children: [],
            ),
          ),
        ],
      ),
    );
  }
}
