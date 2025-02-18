import 'package:flutter/material.dart';

class SearchLobbyView extends StatelessWidget {
  const SearchLobbyView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.history,
                  size: 18,
                ),
                SizedBox(width: 10),
                Text(
                  'Lịch sử tra cứu :',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Divider(color: Colors.grey[350]),
            const SizedBox(height: 5),
            _buildHistoryItem('我们'),
            _buildHistoryItem('你们'),
            _buildHistoryItem('豪门'),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        const SizedBox(height: 5),
        Divider(color: Colors.grey[300]),
      ],
    );
  }
}
