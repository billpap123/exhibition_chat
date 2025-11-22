import 'package:flutter/material.dart';
import 'glyph.dart';
import 'printer_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Here we define our glyphs.
  // First one uses your PNG: assets/glyphs/TEXT-10.png
  // The rest are placeholders with letters only (no image yet).
  final List<Glyph> allGlyphs = [
    Glyph(id: 'TEXT-10', assetPath: 'assets/glyphs/TEXT-10.png'),
    Glyph(id: 'TEXT-11', assetPath: 'assets/glyphs/TEXT-11.png'),
    Glyph(id: 'TEXT-12', assetPath: 'assets/glyphs/TEXT-12.png'),
    Glyph(id: 'TEXT-13', assetPath: 'assets/glyphs/TEXT-13.png'),
    Glyph(id: 'TEXT-14', assetPath: 'assets/glyphs/TEXT-14.png'),
    Glyph(id: 'TEXT-15', assetPath: 'assets/glyphs/TEXT-15.png'),
    Glyph(id: 'TEXT-16', assetPath: 'assets/glyphs/TEXT-16.png'),
    Glyph(id: 'TEXT-17', assetPath: 'assets/glyphs/TEXT-17.png'),
    // note: TEXT-18.png does not exist in your ls
    Glyph(id: 'TEXT-19', assetPath: 'assets/glyphs/TEXT-19.png'),
    Glyph(id: 'TEXT-20', assetPath: 'assets/glyphs/TEXT-20.png'),
    Glyph(id: 'TEXT-21', assetPath: 'assets/glyphs/TEXT-21.png'),
    Glyph(id: 'TEXT-22', assetPath: 'assets/glyphs/TEXT-22.png'),
    Glyph(id: 'TEXT-23', assetPath: 'assets/glyphs/TEXT-23.png'),
    Glyph(id: 'TEXT-24', assetPath: 'assets/glyphs/TEXT-24.png'),
    Glyph(id: 'TEXT-25', assetPath: 'assets/glyphs/TEXT-25.png'),
    Glyph(id: 'TEXT-26', assetPath: 'assets/glyphs/TEXT-26.png'),
    Glyph(id: 'TEXT-27', assetPath: 'assets/glyphs/TEXT-27.png'),
    Glyph(id: 'TEXT-28', assetPath: 'assets/glyphs/TEXT-28.png'),
    Glyph(id: 'TEXT-29', assetPath: 'assets/glyphs/TEXT-29.png'),
    Glyph(id: 'TEXT-30', assetPath: 'assets/glyphs/TEXT-30.png'),
    Glyph(id: 'TEXT-31', assetPath: 'assets/glyphs/TEXT-31.png'),
    Glyph(id: 'TEXT-32', assetPath: 'assets/glyphs/TEXT-32.png'),
    Glyph(id: 'TEXT-33', assetPath: 'assets/glyphs/TEXT-33.png'),
    Glyph(id: 'TEXT-34', assetPath: 'assets/glyphs/TEXT-34.png'),
    Glyph(id: 'TEXT-35', assetPath: 'assets/glyphs/TEXT-35.png'),
    Glyph(id: 'TEXT-36', assetPath: 'assets/glyphs/TEXT-36.png'),
  ];
  final List<Message> messages = [];
  final List<Glyph> currentGlyphs = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // CHAT AREA
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(24),
                itemCount: messages.length,
                itemBuilder: (context, index) {
  final msg = messages[index];
  return AnimatedOpacity(
    duration: const Duration(milliseconds: 500),
    opacity: msg.isVisible ? 1.0 : 0.0,
    child: Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: msg.glyphs
              .map(
                (g) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: g.assetPath.isNotEmpty
                      ? Image.asset(
                          g.assetPath,
                          height: 32,
                          fit: BoxFit.contain,
                        )
                      : Text(
                          g.id,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                ),
              )
              .toList(),
        ),
      ),
    ),
  );
},

              ),
            ),

            const SizedBox(height: 8),

            // BLACK BAR (current message + send arrow)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Current glyph preview
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: currentGlyphs
                            .map(
                              (g) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: g.assetPath.isNotEmpty
    ? Image.asset(
        g.assetPath,
        height: 30,
        fit: BoxFit.contain,
        color: Colors.white,
        colorBlendMode: BlendMode.srcATop,
      )
    : Text(
        g.id,
        style: const TextStyle(
          fontSize: 22,
          color: Colors.white,
        ),
      ),

                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 12),
GestureDetector(
  onTap: currentGlyphs.isEmpty ? null : _onSendPressed,
  child: Opacity(
    // make it “disabled” when no glyphs typed
    opacity: currentGlyphs.isEmpty ? 0.3 : 1.0,
    child: SizedBox(
      width: 70,   // tweak size to match your design
      height: 50,  // tweak height as needed
      child: Image.asset(
        'assets/glyphs/send_button.png', // 👈 your PNG path
        fit: BoxFit.contain,
      ),
    ),
  ),
),

                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // KEYBOARD AREA – custom stepped layout like your design
            // KEYBOARD AREA – custom stepped layout
LayoutBuilder(
  builder: (context, constraints) {
    final width = constraints.maxWidth;
    const outerPadding = 24.0;
    const keyGap = 4.0;

    // διαθέσιμο πλάτος για την 1η σειρά (9 πλήκτρα)
    final row1AvailableWidth = width - 2 * outerPadding;

    // 9 πλήκτρα = 9 key widths + 8 gaps
    final keySize = (row1AvailableWidth - 8 * keyGap) / 9;

    // ένα "slot" = πλήκτρο + gap
    final slotWidth = keySize + keyGap;

    // σπάμε τα glyphs σε σειρές
    final row1 = allGlyphs.sublist(0, 9);        // 9 glyphs
    final row2 = allGlyphs.sublist(9, 16);       // 7 glyphs
    final row3 = allGlyphs.sublist(16, 23);      // 7 glyphs
    final bottomRow = allGlyphs.sublist(23, 26); // 3 glyphs

    // ⌨️ ένα key ΧΩΡΙΣ extra border (έχεις ήδη το πλαίσιο στο png)
    Widget buildKey(Glyph glyph) {
      return GestureDetector(
        onTap: () {
          if (currentGlyphs.length >= 40) return;
          setState(() => currentGlyphs.add(glyph));
        },
        child: SizedBox(
          width: keySize,
          height: keySize,
          child: Center(
            child: Image.asset(
              glyph.assetPath,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }

    // μία σειρά με N πλήκτρα, με custom left indent
    Widget buildRow(List<Glyph> glyphs, double leftIndent) {
      return Padding(
        padding: EdgeInsets.only(left: leftIndent),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < glyphs.length; i++) ...[
              buildKey(glyphs[i]),
              if (i != glyphs.length - 1)
                const SizedBox(width: keyGap),
            ],
          ],
        ),
      );
    }

    // --- OFFSETS (σε "slots") όπως ζήτησες ---

    // 1η σειρά: from outerPadding
    final row1Left = outerPadding;

    // 2η σειρά: 1 slot in
    final row2Left = outerPadding + 1 * slotWidth;

    // 3η σειρά: 1.5 slots in
    final row3Left = outerPadding + 0.5 * slotWidth;

    // 4η σειρά: 4.5 slots in
    final bottomLeft = outerPadding + 3.5 * slotWidth;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        buildRow(row1, row1Left),
        const SizedBox(height: 6),
        buildRow(row2, row2Left),
        const SizedBox(height: 6),
        buildRow(row3, row3Left),
        const SizedBox(height: 18),
        buildRow(bottomRow, bottomLeft),
        const SizedBox(height: 8),
      ],
    );
  },
),


           


            
          ],
        ),
      ),
    );
  }

  Future<void> _onSendPressed() async {
    if (currentGlyphs.isEmpty) return;

    final msg = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      glyphs: List.of(currentGlyphs),
    );

    setState(() {
      messages.add(msg);
    });

    // Auto-scroll to bottom
    await Future.delayed(const Duration(milliseconds: 50));
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    // SEND = INSTANT "PRINT"
    // SEND = INSTANT "PRINT"
  await printerService.printMessage(msg);

  setState(() {
    currentGlyphs.clear();
  });

  // ⏱ keep the message visible for a few seconds, then fade + remove
  const visibleDuration = Duration(seconds: 4);
  const fadeDuration = Duration(milliseconds: 500);

  // after 4 seconds, start fading out
  Future.delayed(visibleDuration, () {
    if (!mounted) return;
    setState(() {
      msg.isVisible = false;
    });

    // after fade animation, remove from list
    Future.delayed(fadeDuration, () {
      if (!mounted) return;
      setState(() {
        messages.removeWhere((m) => m.id == msg.id);
      });
    });
  });
}

}
