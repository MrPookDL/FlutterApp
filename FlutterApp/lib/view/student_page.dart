import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projet_final/data/authentification.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final _formKey = GlobalKey<FormState>();
  String? nom;
  String? prenom;
  int? numDossier;
  String? institution;
  String? email;
  String? photo;
  bool _isEditMode = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('student').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          DocumentSnapshot? studentDocument;

          // Assuming the current user's email is stored in a variable called userEmail.
          String? userEmail = Auth().currentUser!.email;

          for (var doc in snapshot.data!.docs) {
            if (doc.get("email") == userEmail) {
              studentDocument = doc;
              break; // Break out of the loop when we find a match
            }
          }

          // If no matching document is found
          if (studentDocument == null) {
            return const Center(child: Text('No matching data found.'));
          }

          Map<String, dynamic>? data =
              studentDocument.data() as Map<String, dynamic>?;
          nom = data?["nom"];
          prenom = data?["prenom"];
          numDossier = data?["numDossier"];
          institution = data?["institution"];
          email = data?["email"];
          photo = data?["photo"];

          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 216, 231, 243),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 93, 19, 153),
              title: const Text('Profil Étudiant'),
              actions: <Widget>[
                PopupMenuButton<String>(
                  icon: const Icon(Icons.settings),
                  onSelected: (value) {
                    if (value == 'edit') {
                      setState(() {
                        _isEditMode = !_isEditMode;
                      });
                    } else if (value == 'option2') {
                      Auth().signOut();
                      //COMPLETLY LOG OUT
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Modifier Compte'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'option2',
                      child: Text('Déconnexion'),
                    ),
                  ],
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      PhysicalShape(
                        elevation: 5.0,
                        clipper: ShapeBorderClipper(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        color: Colors.blue,
                        child: SizedBox(
                          height: 250.0,
                          width: 600.0,
                          child: Column(children: <Widget>[
                            const SizedBox(height: 30),
                            CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  photo != null ? NetworkImage(photo!) : null,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt),
                                onPressed: () {
                                  //Upload d'une photo
                                },
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                const SizedBox(width: 105),
                                //PRENOM
                                SizedBox(
                                  width: 90,
                                  child: _isEditMode
                                      ? TextFormField(
                                          initialValue: prenom,
                                          decoration: const InputDecoration(
                                            labelText: 'Prénom',
                                          ),
                                          onSaved: (value) => prenom = value,
                                        )
                                      : ListTile(
                                          title: Text(
                                            '$prenom',
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                ),
                                //NOM
                                SizedBox(
                                  width: 100,
                                  child: _isEditMode
                                      ? TextFormField(
                                          initialValue: nom,
                                          decoration: const InputDecoration(
                                            labelText: 'Nom',
                                          ),
                                          onSaved: (value) => nom = value,
                                        )
                                      : ListTile(
                                          title: Text(
                                            '$nom',
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                             Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                ),
                                const VerticalDivider(
                                  width: 10,
                                  thickness: 1,
                                  indent: 20,
                                  endIndent: 0,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 40),
                              ],
                            ),
                          ]),
                        ),
                      ),

                      // CircleAvatar(
                      //   radius: 60,
                      //   backgroundImage:
                      //       photo != null ? NetworkImage(photo!) : null,
                      //   child: IconButton(
                      //     icon: const Icon(Icons.camera_alt),
                      //     onPressed: () {
                      //       //Upload d'une photo
                      //     },
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      // Row(
                      //   children: <Widget>[
                      //     const SizedBox(width: 70),
                      //     //PRENOM
                      //     SizedBox(
                      //       width: 120,
                      //       child: _isEditMode
                      //           ? TextFormField(
                      //               initialValue: prenom,
                      //               decoration: const InputDecoration(
                      //                   labelText: 'Prénom'),
                      //               onSaved: (value) => prenom = value,
                      //             )
                      //           : ListTile(title: Text('$prenom')),
                      //     ),
                      //     const Spacer(),
                      //     //NOM
                      //     SizedBox(
                      //       width: 120,
                      //       child: _isEditMode
                      //           ? TextFormField(
                      //               initialValue: nom,
                      //               decoration: const InputDecoration(
                      //                 labelText: 'Nom',
                      //               ),
                      //               onSaved: (value) => nom = value,
                      //             )
                      //           : ListTile(title: Text('$nom')),
                      //     ),
                      //     const SizedBox(width: 40),
                      //   ],
                      // ),
                      //COURRIEL
                      _isEditMode
                          ? TextFormField(
                              initialValue: email,
                              decoration:
                                  const InputDecoration(labelText: 'email'),
                              onSaved: (value) => email = value,
                            )
                          : ListTile(
                              // titleAlignment: ,
                              title: Text('$email'),
                              leading: const Icon(Icons.mail),
                            ),
                      //NUMÉRO DOSSIER
                      _isEditMode
                          ? TextFormField(
                              initialValue: numDossier?.toString(),
                              decoration: const InputDecoration(
                                  labelText: 'Numéro de dossier'),
                              onSaved: (value) {
                                numDossier = int.tryParse(value ?? '');
                              },
                              keyboardType: TextInputType.number,
                            )
                          : ListTile(
                              title: Text(numDossier?.toString() ?? 'N/A'),
                              leading: const Icon(Icons.numbers_rounded),
                            ),
                      //INSTITUTION
                      _isEditMode
                          ? TextFormField(
                              initialValue: institution,
                              decoration: const InputDecoration(
                                  labelText: 'Institution'),
                              onSaved: (value) => institution = value,
                            )
                          : ListTile(
                              leading: const Icon(Icons.house_rounded),
                              title: Text('$institution'),
                            ),
                      _isEditMode
                          ? ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  //Mettre firebase à jour
                                  DocumentReference studentDocRef =
                                      FirebaseFirestore.instance
                                          .collection('student')
                                          .doc(studentDocument?.id);
                                  try {
                                    await studentDocRef.update({
                                      "nom": nom,
                                      "prenom": prenom,
                                      "numDossier": numDossier,
                                      "institution": institution,
                                      "email": email,
                                    });

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'Les données ont été sauvegardé!'),
                                      ));

                                      setState(() {
                                        _isEditMode = false;
                                      });
                                    }
                                  } catch (error) {
                                    if (kDebugMode) {
                                      print(
                                          "Erreur lors de la sauvegarde des données: $error");
                                    }
                                  }
                                }
                              },
                              child: const Text('Sauvegarder'),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
