import 'dart:ui';

class Book {
  String? coverImageUrl;
  String? title;
  DateTime? lastSeen;

  Book.withUrl(String coverImageUrl, String title, DateTime lastSeen) {
    this.coverImageUrl = coverImageUrl;
    this.title = title;
    this.lastSeen = lastSeen;
  }

}