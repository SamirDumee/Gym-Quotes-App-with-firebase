import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fun_facts/services/firestore.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  // instance of firestoreservice
  FirestoreService firestoreService = FirestoreService();

// delete quotes from favorites
  void deleteQuote(String docId) {
    // alert dialog to delete quote
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Do you want to remove it from favorites?",
        ),
        actions: [
          // button to delete the quote
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);

              // deleting with error handling
              if (docId.isNotEmpty) {
                firestoreService.deleteFavoriteQuote(docId).then((_) {
                  setState(() {
                    docId = ''; // Reset the docId after deletion
                  });
                }).catchError((error) {
                  // print any error that may occur during deletion
                  print("Error deleting document: $error");
                });
              }
            },
            child: const Text("Remove"),
          ),

          // delete cancel button
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  String currentQuote = ''; // Store the currently viewed quote
  String docId = ''; // store the document Id of currently viewed quote

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 60.0),
            child: IconButton(
              onPressed: () {
                deleteQuote(docId);
              },
              icon: const Icon(
                Icons.delete,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: firestoreService.getFavoriteStream(),
        builder: (context, snapshot) {
          // storing the quotes in list
          if (snapshot.hasData) {
            List quotesList = snapshot.data!.docs;

            // If no quotes left, show empty message
            if (quotesList.isEmpty) {
              return const Center(
                child: Text("No Quotes at the moment"),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    itemCount: quotesList.length,
                    onPageChanged: (index) {
                      // Update the current quote and docId whenever the page changes
                      DocumentSnapshot document = quotesList[index];
                      setState(() {
                        docId = document.id;
                        currentQuote =
                            (document.data() as Map<String, dynamic>)["quote"];
                      });
                    },
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = quotesList[index];
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
