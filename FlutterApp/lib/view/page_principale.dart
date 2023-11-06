import 'package:flutter/material.dart';
import 'package:projet_final/model/carousel.dart';
import 'package:projet_final/model/hero_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projet_final/view/student_page.dart';

class PagePrincipale extends StatelessWidget {
  const PagePrincipale({super.key});

  @override
  Widget build(BuildContext context) {
//DATABASE//////////////////////////////
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cours').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;
//DATABASE///////////////////////////////
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 216, 231, 243),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 93, 19, 153),
              title: const Text('ClassHub'),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.person_2),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return const StudentPage();
                      },
                    ));
                  },
                ),
              ],
            ),
            body: Column(children: [
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'Actualités',
                  style: TextStyle(
                    fontFamily: AutofillHints.countryName,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 2,
                indent: 30,
                endIndent: 30,
              ),
              const MyCarouselPage(),
              const SizedBox(height: 20),
////////////////////////////////
              Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final item = documents[index].get("nom");
                      final description = documents[index].get("description");
                      final image = documents[index].get("image");
                      final id = documents[index].get("id");

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            // Hero
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ImageDetailPage(
                                    image: image ?? 'asset/images/caca.png',
                                    tag: 'imageHero$id',
                                    title: item,
                                    description: description,
                                  ),
                                ));
                              },
                              child: Hero(
                                tag: 'imageHero$index',
                                child: image != null && image!.isNotEmpty
                                    ? FadeInImage.assetNetwork(
                                        placeholder: 'asset/images/caca.png',
                                        image: image!,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'asset/images/caca.png',
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),

                            // Gap between image and title
                            const SizedBox(width: 20),

                            // Title
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                // color: Colors.amber,
                                child: Text(
                                  item!,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ]),
          );
        });
  }
}
