import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projet_final/data/authentification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _errorMessage = '';
  bool isLogin = true;
  bool _isPasswordVisible = false;
  final TextEditingController _controllerConfirmPasswordRegister =
      TextEditingController();

//For Login
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
//For Registering`
  final TextEditingController _controllerEmailRegister =
      TextEditingController();
  final TextEditingController _controllerPasswordRegister =
      TextEditingController();
//Database
  final TextEditingController _controllerNom = TextEditingController();
  final TextEditingController _controllerPrenom = TextEditingController();
  final TextEditingController _controllerNumDossier = TextEditingController();
  final TextEditingController _controllerInstitution = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? '';
      });
    }
  }

  Future<bool> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPasswordAndAddToDB(
        email: _controllerEmailRegister.text,
        password: _controllerPasswordRegister.text,
        nom: _controllerNom.text,
        prenom: _controllerPrenom.text,
        numDossier: int.tryParse(_controllerNumDossier.text) ?? 1,
        institution: _controllerInstitution.text,
        photo:
            'https://static.vecteezy.com/system/resources/thumbnails/009/734/564/small/default-avatar-profile-icon-of-social-media-user-vector.jpg',
      );
      // Clear the fields here
      _controllerEmailRegister.clear();
      _controllerPasswordRegister.clear();
      _controllerConfirmPasswordRegister.clear();
      _controllerNom.clear();
      _controllerPrenom.clear();
      _controllerNumDossier.clear();
      _controllerInstitution.clear();
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  final _formKey = GlobalKey<FormState>();

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false, String? Function(String?)? validator}) {
    return TextFormField(
      cursorColor: const Color.fromARGB(255, 33, 46, 131),
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: const TextStyle(color: Colors.black),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 33, 46, 131)),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
      ),
      validator: validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Ce champ ne peut pas être vide';
            }
            if (isPassword && value.length < 6) {
              return 'Le mot de passe doit contenir au moins 6 caractères';
            }
            return null;
          },
    );
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ce champ ne peut pas être vide';
    } else if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    } else if (value != _controllerPasswordRegister.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  Widget _errorMessageWidget() {
    return Text(
      _errorMessage == '' ? '' : _errorMessage,
      style: const TextStyle(color: Color.fromARGB(255, 33, 46, 131)),
    );
  }

  Widget _submitButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 45, 44, 44)),
        onPressed: isLogin
            ? signInWithEmailAndPassword
            : createUserWithEmailAndPassword,
        child: Text(
          isLogin ? 'Confirmer' : 'Enregistrer',
          style: const TextStyle(
            color: Colors.white,
          ),
        ));
  }

///////////////ACCOUNT CREATION AT LOGIN///////////////
  void _showRegistrationForm(BuildContext context) {
    bool hasAcceptedConditions = false;

    showDialog(
      barrierColor: const Color.fromARGB(94, 67, 86, 208),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                "Création de compte étudiant",
                style: TextStyle(
                  color: Color.fromARGB(255, 24, 39, 132),
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _entryField('Courriel', _controllerEmailRegister,
                          validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'L\'adresse courriel est requise';
                        }
                        // Add any other email validation logic here if needed
                        return null;
                      }),
                      const SizedBox(height: 10),
                      _entryField(
                        'Mot de passe',
                        _controllerPasswordRegister,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Le mot de passe est requis';
                          } else if (value.length < 6) {
                            return 'Le mot de passe doit contenir au moins 6 caractères';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      _entryField(
                        'Confirmer le mot de passe',
                        _controllerConfirmPasswordRegister,
                        isPassword: true,
                        validator: _validateConfirmPassword,
                      ),
                      const SizedBox(height: 10),
                      _entryField('Nom', _controllerNom),
                      const SizedBox(height: 10),
                      _entryField('Prenom', _controllerPrenom),
                      const SizedBox(height: 10),
                      _entryField('Numéro de Dossier', _controllerNumDossier),
                      const SizedBox(height: 10),
                      _entryField('Institution', _controllerInstitution),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: hasAcceptedConditions,
                            onChanged: (bool? value) {
                              setState(() {
                                hasAcceptedConditions = value ?? false;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 24, 39, 132),
                          ),
                          const Expanded(
                              child: Text(
                                  "J'accepte les conditions d'utilisation")),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 67, 86, 208),
                        ),
                        onPressed: hasAcceptedConditions
                            ? () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    bool success =
                                        await createUserWithEmailAndPassword();
                                    if (success) {
                                      if (context.mounted) {
                                        // Instead of popping the dialog, show a success message
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Inscription réussie!')),
                                        );
                                        // Optionally, reset the form or perform other actions here
                                        _formKey.currentState?.reset();
                                        // Do not navigate away, just close the dialog
                                        Navigator.of(context).pop();
                                      }
                                    } else {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Inscription échouée. Veuillez réessayer.')));
                                      }
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Une erreur est survenue: $e')));
                                    }
                                  }
                                }
                              }
                            : null,
                        child: const Text('Enregistrer'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _loginOrRegistrationButton() {
    return TextButton(
      onPressed: () {
        if (isLogin) {
          _showRegistrationForm(context);
        } else {
          setState(() {
            isLogin = !isLogin;
          });
        }
      },
      child: Text(
        isLogin ? 'Créer un compte' : 'Connexion',
        style: const TextStyle(color: Color.fromARGB(255, 33, 46, 131)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 1),
              colors: <Color>[
                Color(0xff1f005c),
                Color(0xff5b0060),
                Color.fromARGB(255, 222, 196, 214),
                Color.fromARGB(255, 232, 196, 211),
                Color.fromARGB(255, 238, 188, 196),
                Color.fromARGB(255, 241, 172, 163),
                Color(0xfff39060),
                Color(0xffffb56b),
              ],
              tileMode: TileMode.mirror,
            ),
          ),
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Connexion',
                  style: TextStyle(
                      fontFamily: AutofillHints.countryName,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: _entryField('Courriel', _controllerEmail),
              ),
              Container(
                child: _entryField('Mot de passe', _controllerPassword),
              ),
              _errorMessageWidget(),
              Container(
                alignment: FractionalOffset.centerRight,
                child: _loginOrRegistrationButton(),
              ),
              Container(
                alignment: FractionalOffset.centerRight,
                child: _submitButton(),
              ),
            ],
          )),
    );
  }
}
