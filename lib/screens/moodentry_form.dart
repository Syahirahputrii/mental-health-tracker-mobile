import 'package:flutter/material.dart';
import 'package:mental_health_tracker/widgets/left_drawer.dart'; // Import LeftDrawer widget
import 'package:provider/provider.dart'; // Import untuk context.watch
import 'package:pbp_django_auth/pbp_django_auth.dart'; // Import untuk CookieRequest
import 'dart:convert'; // Import untuk jsonEncode
import 'package:mental_health_tracker/screens/menu.dart'; // Import untuk navigasi ke MyHomePage

class MoodEntryFormPage extends StatefulWidget {
  const MoodEntryFormPage({super.key});

  @override
  State<MoodEntryFormPage> createState() => _MoodEntryFormPageState();
}

class _MoodEntryFormPageState extends State<MoodEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _mood = "";
  String _feelings = "";
  int _moodIntensity = 0;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>(); // Menyambungkan dengan CookieRequest

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Entry Form'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mood field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Mood",
                    labelText: "Mood",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _mood = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Mood tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // Feelings field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Feelings",
                    labelText: "Feelings",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _feelings = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Feelings tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // Mood intensity field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Mood intensity",
                    labelText: "Mood intensity",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (String? value) {
                    setState(() {
                      _moodIntensity = int.tryParse(value!) ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Mood intensity tidak boleh kosong!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Mood intensity harus berupa angka!";
                    }
                    return null;
                  },
                ),
              ),
              // Save button
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Mengirim data ke backend Django
                        final response = await request.postJson(
                          "http://[URL_APP_KAMU]/create-flutter/", // Ganti dengan URL backend yang sesuai
                          jsonEncode(<String, String>{
                            'mood': _mood,
                            'mood_intensity': _moodIntensity.toString(),
                            'feelings': _feelings,
                          }),
                        );

                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Mood baru berhasil disimpan!"),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomePage(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Terdapat kesalahan, silakan coba lagi."),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
