import 'package:flutter/material.dart';

class ImageDetailPage extends StatelessWidget {
  final String image;
  final String tag;
  final String title;
  final String description;

  const ImageDetailPage({
    super.key,
    required this.image,
    required this.tag,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 216, 231, 243),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 93, 19, 153),
        title: const Text('En détail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: tag,
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                width: 300.0, // set the desired width
                height: 450.0, // set the desired height
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/caca.png',
                  image: image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
