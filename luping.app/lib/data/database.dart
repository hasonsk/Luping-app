import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luping/models/hint_character.dart'; // Import lớp hintCharacter

class DatabaseService {
  final CollectionReference characterCollection =
      FirebaseFirestore.instance.collection('characters');

  // Method to search for documents where 'Hanzi' field contains any of the given characters
  Future<List<HintCharacter>> hintSearch(List<String> characters) async {
    if (characters.isEmpty) {
      return [];
    }

    // Create queries with a limit of 10 documents
    List<Query> queries = [
      characterCollection
          .where('Hanzi', isGreaterThanOrEqualTo: characters.join(''))
          .where('Hanzi', isLessThan: '${characters.join('')}\uf8ff')
          .limit(10) // Limit the number of documents returned
    ];

    // Perform the combined query
    List<DocumentSnapshot> allDocs = [];
    for (var query in queries) {
      QuerySnapshot querySnapshot = await query.get();
      allDocs.addAll(querySnapshot.docs);
      if (allDocs.length >= 10) {
        break; // Stop querying if we have reached the limit of 10 documents
      }
    }

    // Use a set to handle duplicates
    Set<HintCharacter> resultSet = {};
    for (var doc in allDocs) {
      final data = doc.data() as Map<String, dynamic>;

      // Extract HanViet and check if it's a list
      var hanVietField = data['HanViet'];
      String hanViet = '';
      if (hanVietField is List) {
        if (hanVietField.isNotEmpty) {
          hanViet = hanVietField.last; // Get the last element of the list
        }
      } else {
        hanViet = hanVietField ?? '';
      }

      resultSet.add(HintCharacter(
        hanzi: data['Hanzi'] ?? '',
        pinyin: data['Pinyin'] ?? '',
        hanViet: hanViet,
        shortmeaning: data['shortmeaning'] ?? '',
      ));
      if (resultSet.length >= 10) {
        break; // Stop processing if we have reached the limit of 10 documents
      }
    }

    // Convert resultSet to List and limit to 10 items
    List<HintCharacter> result = resultSet.take(10).toList();

    return result;
  }
}
