import 'package:flutter/material.dart';
import 'package:mental_health_tracker/screens/moodentry_form.dart';
import 'package:mental_health_tracker/screens/list_moodentry.dart'; // Import halaman MoodEntryPage
import 'package:mental_health_tracker/screens/login.dart'; // Import halaman LoginPage untuk navigasi setelah logout
import 'package:pbp_django_auth/pbp_django_auth.dart'; // Import CookieRequest untuk autentikasi
import 'package:provider/provider.dart'; // Import Provider untuk context.watch

class ItemHomepage {
  final String name;
  final IconData icon;

  ItemHomepage(this.name, this.icon);
}

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>(); // Mengakses CookieRequest

    return Material(
      color: Theme.of(context).colorScheme.secondary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () async {
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));

          // Navigate ke route yang sesuai (tergantung jenis tombol)
          if (item.name == "Tambah Mood") {
            // Navigasi ke halaman MoodEntryFormPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MoodEntryFormPage()),
            );
          } else if (item.name == "Lihat Mood") {
            // Navigasi ke halaman MoodEntryPage (Lihat Mood)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MoodEntryPage()),
            );
          } else if (item.name == "Logout") {
            // Proses logout secara asinkron
            final response = await request.logout(
              "http://[APP_URL_KAMU]/auth/logout/"); // Ganti URL dengan URL logout Anda

            String message = response["message"];
            if (context.mounted) {
              if (response['status']) {
                String uname = response["username"];
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$message Sampai jumpa, $uname."),
                ));
                // Navigasi ke halaman Login setelah logout berhasil
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );
              }
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
