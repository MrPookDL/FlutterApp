import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MyCarouselPage extends StatefulWidget {
  const MyCarouselPage({super.key});

  @override
  _MyCarouselPageState createState() => _MyCarouselPageState();
}

List<String> imageUrls = [
  'https://contentstatic.techgig.com/photo/99194118.cms',
  'https://miro.medium.com/v2/resize:fit:1400/0*z1mm6izqSeDiKukb',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-yaJW2jxKTuAJbtydERJYBoI6brAKKodV2g&usqp=CAU',
  'https://lesjoiesducode.fr/content/044/front-end-back-end-week-end-drake-meme-developpeur.jpg',
  'https://i.imgur.com/VxswFYF.jpeg',
];

class _MyCarouselPageState extends State<MyCarouselPage> {
  int _currentIndex = 0;

  List<Widget> _buildPageIndicators(int length) {
    List<Widget> indicators = [];
    for (int i = 0; i < length; i++) {
      indicators.add(
        Container(
          width: 8.0, // Adjusted size to accommodate the border
          height: 8.0, // Adjusted size to accommodate the border
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentIndex == i
                ? Colors.grey[800]
                : const Color.fromARGB(255, 224, 224, 224),
            border: Border.all(
              // This adds the border
              color: Colors.grey[800]!,
              width: 1.0,
            ),
          ),
        ),
      );
    }
    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              height: 200.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              }),
          items: imageUrls.map((url) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: const BoxDecoration(
                      color:Color.fromARGB(224, 93, 19, 153),
                    ),
                    child: Image.network(
                      url,
                      fit: BoxFit.contain,
                    ));
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildPageIndicators(6),
        ),
      ],
    );
  }
}
