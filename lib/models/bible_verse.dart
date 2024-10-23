class Verse {
  final String reference;
  final String text;
  final String bookName;
  final int chapter;
  final int verse;

  Verse({
    required this.reference,
    required this.text,
    required this.bookName,
    required this.chapter,
    required this.verse,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      reference: json['reference'],
      text: json['text'],
      bookName: json['verses'][0]['book_name'],
      chapter: json['verses'][0]['chapter'],
      verse: json['verses'][0]['verse'],
    );
  }
}