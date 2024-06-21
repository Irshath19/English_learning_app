import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'video_player_widget.dart';

class Vocabulary extends StatefulWidget {
  @override
  _VocabularyState createState() => _VocabularyState();
}

class _VocabularyState extends State<Vocabulary> {
  List<VocabularyItem> vocals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVocabularies();
  }

  Future<void> fetchVocabularies() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/vocabularies'));

      if (response.statusCode == 200) {
        final List<dynamic> vocabularyList = jsonDecode(response.body);
        setState(() {
          vocals = vocabularyList
              .map((item) => VocabularyItem(
                    name: item['name'],
                  ))
              .toList();
          isLoading = false;
        });
      } else {
        print('Failed to fetch vocabularies: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching vocabularies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Vocabulary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: vocals.length,
              itemBuilder: (context, index) {
                return CustomContactTile(vocal: vocals[index]);
              },
            ),
    );
  }
}

class CustomContactTile extends StatelessWidget {
  final VocabularyItem vocal;

  CustomContactTile({required this.vocal});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(videoName: vocal.name)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.blueGrey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  vocal.name[0],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vocal.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to play video',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.play_circle_fill,
              color: Colors.green,
              size: 32.0,
            ),
          ],
        ),
      ),
    );
  }
}

class VocabularyItem {
  final String name;
  VocabularyItem({required this.name});
}



// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'video_player_widget.dart';

// class Vocabulary extends StatefulWidget {
//   @override
//   _VocabularyState createState() => _VocabularyState();
// }

// class _VocabularyState extends State<Vocabulary> {
//   List<VocabularyItem> vocals = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchVocabularies();
//   }

//   Future<void> fetchVocabularies() async {
//     try {
//       final response =
//           await http.get(Uri.parse('http://localhost:3000/vocabularies'));

//       if (response.statusCode == 200) {
//         final List<dynamic> vocabularyList = jsonDecode(response.body);
//         setState(() {
//           vocals = vocabularyList
//               .map((item) => VocabularyItem(
//                     name: item['name'],
//                   ))
//               .toList();
//           isLoading = false;
//         });
//       } else {
//         print('Failed to fetch vocabularies: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching vocabularies: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(
//           child: Text(
//             'Vocabulary',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//       body: isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : ListView.builder(
//               itemCount: vocals.length,
//               itemBuilder: (context, index) {
//                 return CustomContactTile(vocal: vocals[index]);
//               },
//             ),
//     );
//   }
// }

// class CustomContactTile extends StatelessWidget {
//   final VocabularyItem vocal;

//   CustomContactTile({required this.vocal});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => VideoPlayerScreen(videoName: vocal.name)),
//         );
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         child: Row(
//           children: [
//             CircleAvatar(
//               child: Text(vocal
//                   .name[0]), // Display the first letter of the vocabulary name
//             ),
//             const SizedBox(width: 16.0),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   vocal.name,
//                   style: const TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class VocabularyItem {
//   final String name;

//   VocabularyItem({required this.name});
// }



// import 'package:english_learning/Components/video_player_widget.dart';
// import 'package:flutter/material.dart';

// class Vocabulary extends StatelessWidget {
//   final List<vocabulary> vocals = [
//     vocabulary(name: 'vocabulary 1', filename: 'vocabulary1'),
//     vocabulary(name: 'vocabulary 2', filename: 'vocabulary2'),
//     vocabulary(name: 'vocabulary 3', filename: 'vocabulary3'),
//     vocabulary(name: 'vocabulary 4', filename: 'vocabulary4'),
//     vocabulary(name: 'vocabulary 5', filename: 'vocabulary5'),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(
//           child: Text(
//             'Vocabulary',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//       body: ListView.builder(
//         itemCount: vocals.length,
//         itemBuilder: (context, index) {
//           return CustomContactTile(vocal: vocals[index]);
//         },
//       ),
//     );
//   }
// }

// class CustomContactTile extends StatelessWidget {
//   final vocabulary vocal;

//   CustomContactTile({required this.vocal});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         // Handle contact tap
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//                   VideoPlayerScreen(videoName: vocal.filename)),
//         );
//       },
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         child: Row(
//           children: [
//             CircleAvatar(
//               child: Text(vocal.name[vocal.name.length - 1]),
//             ),
//             const SizedBox(width: 16.0),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   vocal.name,
//                   style: const TextStyle(
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class vocabulary {
//   final String name;
//   final String filename;

//   vocabulary({required this.name, required this.filename});
// }
