import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Components/video_player_widget.dart';

class VocalUploader extends StatefulWidget {
  @override
  _VocalUploaderState createState() => _VocalUploaderState();
}

class _VocalUploaderState extends State<VocalUploader> {
  String statusMessage = "No upload";

  String? _fileName;
  bool _isUploading = false;
  String _uploadStatus = '';
  String? _videoId;
  TextEditingController _fileNameController = TextEditingController();

  Future<void> pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _fileName = file.name;
      });
      await encodeAndUploadVideo(file);
    } else {
      setState(() {
        _uploadStatus = 'User canceled the picker';
      });
    }
  }

  Future<void> encodeAndUploadVideo(PlatformFile file) async {
    setState(() {
      _isUploading = true;
      _uploadStatus = 'Uploading...';
    });

    try {
      List<int> videoBytes = file.bytes!;
      String base64String = base64Encode(videoBytes);
      await uploadVideo(base64String);
    } catch (e) {
      setState(() {
        _uploadStatus = 'Failed to encode and upload video: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload Status'),
          content: Text("Video uploaded"),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // _refreshPage();
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadVideo(String base64String) async {
    var url = Uri.parse('http://localhost:3000/vocalupload');
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'video': base64String,
          'filename': _fileNameController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        _videoId = responseBody['id'];
        setState(() {
          _uploadStatus = 'Video uploaded successfully';
        });
      } else {
        setState(() {
          _uploadStatus = 'Failed to upload video: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _uploadStatus = 'Failed to upload video: $e';
      });
    }
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Uploader'),
      ),
      body: Center(
        child: _isUploading
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Upload a Video',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _fileNameController,
                      decoration: InputDecoration(
                        labelText: 'Video Filename',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.file_copy),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await pickVideo();
                        showUploadDialog(context);
                      },
                      icon: Icon(Icons.upload_file),
                      label: Text('Pick and Upload Video'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        textStyle: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Text(
                    //   _uploadStatus,
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     color: _uploadStatus.contains('Failed')
                    //         ? Colors.red
                    //         : Colors.green,
                    //   ),
                    // ),
                  ],
                ),
              ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class VocalUploader extends StatefulWidget {
//   @override
//   _VocalUploaderState createState() => _VocalUploaderState();
// }

// class _VocalUploaderState extends State<VocalUploader> {
//   String? _fileName;
//   bool _isUploading = false;
//   String _uploadStatus = '';
//   String? _videoId;
//   TextEditingController _fileNameController = TextEditingController();

//   Future<void> pickVideo() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.video,
//     );

//     if (result != null) {
//       PlatformFile file = result.files.first;
//       setState(() {
//         _fileName = file.name;
//       });
//       await encodeAndUploadVideo(file);
//     } else {
//       setState(() {
//         _uploadStatus = 'User canceled the picker';
//       });
//     }
//   }

//   Future<void> encodeAndUploadVideo(PlatformFile file) async {
//     setState(() {
//       _isUploading = true;
//       _uploadStatus = 'Uploading...';
//     });

//     try {
//       List<int> videoBytes = file.bytes!;
//       String base64String = base64Encode(videoBytes);
//       await uploadVideo(base64String);
//     } catch (e) {
//       setState(() {
//         _uploadStatus = 'Failed to encode and upload video: $e';
//       });
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }

//   void showUploadDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Upload Status'),
//           content: Text('Video uploaded'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> uploadVideo(String base64String) async {
//     var url = Uri.parse('http://localhost:3000/vocalupload');
//     try {
//       var response = await http.post(
//         url,
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, String>{
//           'video': base64String,
//           'filename': _fileNameController.text.trim(),
//         }),
//       );

//       if (response.statusCode == 200) {
//         var responseBody = jsonDecode(response.body);
//         _videoId = responseBody['id'];
//         setState(() {
//           _uploadStatus = 'Video uploaded successfully';
//         });
//       } else {
//         setState(() {
//           _uploadStatus = 'Failed to upload video: ${response.body}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _uploadStatus = 'Failed to upload video: $e';
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _fileNameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Uploader'),
//         backgroundColor: Colors.teal,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.info),
//             onPressed: () {
//               // Info button action
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Card(
//             elevation: 8,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: _isUploading
//                   ? CircularProgressIndicator()
//                   : Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         ListTile(
//                           leading:
//                               Icon(Icons.video_collection, color: Colors.teal),
//                           title: TextField(
//                             controller: _fileNameController,
//                             decoration: const InputDecoration(
//                               hintText: 'Enter video filename',
//                               labelText: 'Video Filename',
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: () async {
//                             await pickVideo();
//                             showUploadDialog(context);
//                           },
//                           style: ElevatedButton.styleFrom(
//                             primary: Colors.teal,
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 20, vertical: 12),
//                             textStyle: TextStyle(fontSize: 18),
//                           ),
//                           child: const Text('Upload Video'),
//                         ),
//                         if (_uploadStatus.isNotEmpty) ...[
//                           SizedBox(height: 20),
//                           Text(
//                             _uploadStatus,
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ],
//                       ],
//                     ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'video_player_widget.dart';

// class VocalUploader extends StatefulWidget {
//   @override
//   _VocalUploaderState createState() => _VocalUploaderState();
// }

// class _VocalUploaderState extends State<VocalUploader> {
//   String? _fileName;
//   bool _isUploading = false;
//   String _uploadStatus = '';
//   String? _videoId;
//   TextEditingController _fileNameController = TextEditingController();

//   Future<void> pickVideo() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.video,
//     );

//     if (result != null) {
//       PlatformFile file = result.files.first;
//       setState(() {
//         _fileName = file.name;
//       });
//       await encodeAndUploadVideo(file);
//       print("1");
//     } else {
//       setState(() {
//         _uploadStatus = 'User canceled the picker';
//       });
//     }
//   }

//   Future<void> encodeAndUploadVideo(PlatformFile file) async {
//     setState(() {
//       _isUploading = true;
//       _uploadStatus = 'Uploading...';
//     });

//     try {
//       List<int> videoBytes = file.bytes!;
//       String base64String = base64Encode(videoBytes);
//       await uploadVideo(base64String);
//     } catch (e) {
//       setState(() {
//         _uploadStatus = 'Failed to encode and upload video: $e';
//       });
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }

//   void showUploadDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Upload Status'),
//           content: Text('Video uploaded'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> uploadVideo(String base64String) async {
//     var url = Uri.parse('http://localhost:3000/vocalupload');
//     try {
//       var response = await http.post(
//         url,
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, String>{
//           'video': base64String,
//           'filename':
//               _fileNameController.text.trim(), // Get filename from text field
//         }),
//       );

//       if (response.statusCode == 200) {
//         var responseBody = jsonDecode(response.body);
//         _videoId = responseBody['id'];
//         setState(() {
//           _uploadStatus = 'Video uploaded successfully';
//         });
//       } else {
//         setState(() {
//           _uploadStatus = 'Failed to upload video: ${response.body}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _uploadStatus = 'Failed to upload video: $e';
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _fileNameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Uploader'),
//       ),
//       body: Center(
//         child: _isUploading
//             ? CircularProgressIndicator()
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   TextField(
//                     controller: _fileNameController,
//                     decoration: const InputDecoration(
//                       hintText: 'Enter video filename',
//                       labelText: 'Video Filename',
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       await pickVideo();
//                       showUploadDialog(context);
//                     },
//                     child: const Text('upload Video'),
//                   ),
//                   // if (_uploadStatus.isNotEmpty) Text(_uploadStatus),
//                   // if (_videoId != null)
//                   //   ElevatedButton(
//                   //     onPressed: () {
//                   //       showDialog(
//                   //         context: context,
//                   //         builder: (BuildContext context) {
//                   //           return AlertDialog(
//                   //             title: Text('Upload Status'),
//                   //             content: Text('Video uploaded'),
//                   //             actions: <Widget>[
//                   //               TextButton(
//                   //                 child: Text('OK'),
//                   //                 onPressed: () {
//                   //                   Navigator.of(context).pop();
//                   //                 },
//                   //               ),
//                   //             ],
//                   //           );
//                   //         },
//                   //       );
//                   //     },
//                   //     child: Text('Upload Video'),
//                   //   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

