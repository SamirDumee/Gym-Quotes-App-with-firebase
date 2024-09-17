import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fun_facts/components/my_drawer.dart';
import 'package:fun_facts/pages/settings_page.dart';
import 'package:fun_facts/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage> {
  FirestoreService firestoreService = FirestoreService();
  List<DocumentSnapshot> shuffledQuotes = [];

  String currentQuote = ''; // Store the currently viewed quote

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {
                // Add current quote to the 'favorite_quote' collection
                if (currentQuote.isNotEmpty) {
                  firestoreService.addQuotesToFavorite(currentQuote, context);
                }
              },
              icon: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30.0, left: 15),
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              ),
              child: const Icon(Icons.settings),
            ),
          )
        ],
        title: const Center(
          child: Text(
            "Gym Quotes",
          ),
        ),
      ),
      body: StreamBuilder(
        stream: firestoreService.getQuotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List quotesList = snapshot.data!.docs;
            if (shuffledQuotes.isEmpty) {
              shuffledQuotes = List.from(quotesList); // Clone the original list
              shuffledQuotes.shuffle(); // Shuffle the cloned list
            }
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: shuffledQuotes.length,
                    onPageChanged: (index) {
                      // Update the current quote whenever the page changes
                      DocumentSnapshot document = shuffledQuotes[index];
                      setState(() {
                        currentQuote =
                            (document.data() as Map<String, dynamic>)["quote"];
                      });
                    },
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = shuffledQuotes[index];
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String quoteText = data["quote"];
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Text(
                            quoteText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    "Swipe left for more",
                  ),
                ),
              ],
            );
          } else {
            return const Text("No Quotes at the moment");
          }
        },
      ),
    );
  }
}
