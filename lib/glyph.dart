class Glyph {
  final String id;
  final String assetPath; // e.g. 'assets/glyphs/g1.png'

  Glyph({required this.id, required this.assetPath});
}

class Message {
  final String id;
  final List<Glyph> glyphs;
  final DateTime createdAt;
  bool isVisible;

  Message({
    required this.id,
    required this.glyphs,
    DateTime? createdAt,
    this.isVisible = true,
  }) : createdAt = createdAt ?? DateTime.now();
}
