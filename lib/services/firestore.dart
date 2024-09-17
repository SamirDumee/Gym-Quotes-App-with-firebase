// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
// get collection of quotes
  final CollectionReference quotesText =
      FirebaseFirestore.instance.collection("quotes");
  final CollectionReference favoriteQuote =
      FirebaseFirestore.instance.collection("favorite_quotes");

// add quote to favorites
  Future<void> addQuotesToFavorite(String quote, BuildContext context) async {
    try {
      // Use the hash code as the document ID
      String docId = quote.hashCode.toString();

      // Check if the quote already exists in favorites
      DocumentSnapshot doc = await favoriteQuote.doc(docId).get();

      if (doc.exists) {
        // If the quote is already in favorites
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The quote is already added!'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // If not, add the quote to the collection
        await favoriteQuote.doc(docId).set({
          'quote': quote,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Added to favorites!'),
          ),
        );
      }
    } catch (e) {
      return;
    }
  }

  // Read quotes from favoite collection
  Stream<QuerySnapshot> getFavoriteStream() {
    final favoriteQuotesStream = favoriteQuote.snapshots();
    return favoriteQuotesStream;
  }

// READ quotes from quotes collection
  Stream<QuerySnapshot> getQuotesStream() {
    final quotesStream = quotesText.snapshots();
    return quotesStream;
  }

// DELETE
  Future<void> deleteFavoriteQuote(String docId) {
    return favoriteQuote.doc(docId).delete();
  }
}
