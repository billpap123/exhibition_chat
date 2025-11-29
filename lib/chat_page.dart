import 'package:flutter/material.dart';
import 'glyph.dart';
import 'printer_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Your glyph PNGs
  final List<Glyph> allGlyphs = [
    Glyph(id: 'TEXT-10', assetPath: 'assets/glyphs/TEXT-10.png'),
    Glyph(id: 'TEXT-11', assetPath: 'assets/glyphs/TEXT-11.png'),
    Glyph(id: 'TEXT-12', assetPath: 'assets/glyphs/TEXT-12.png'),
    Glyph(id: 'TEXT-13', assetPath: 'assets/glyphs/TEXT-13.png'),
    Glyph(id: 'TEXT-14', assetPath: 'assets/glyphs/TEXT-14.png'),
    Glyph(id: 'TEXT-15', assetPath: 'assets/glyphs/TEXT-15.png'),
    Glyph(id: 'TEXT-16', assetPath: 'assets/glyphs/TEXT-16.png'),
    Glyph(id: 'TEXT-17', assetPath: 'assets/glyphs/TEXT-17.png'),
    // TEXT-18 missing
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

  // special glyph for space (no image, invisible)
  Glyph get _spaceGlyph => Glyph(id: 'SPACE', assetPath: '');

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
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          // BUBBLE CONTENT – glyphs big & overlapping, wrapping nicely
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final glyphs = msg.glyphs;

                              const double cellWidth = 80.0;
                              const double cellHeight = 80.0;
                              const double overlap = 18.0;

                              final double effectiveWidth =
                                  cellWidth - overlap;

                              int perRow =
                                  (constraints.maxWidth / effectiveWidth)
                                      .floor();
                              if (perRow < 1) perRow = 1;

                              final List<List<Glyph>> rows = [];
                              for (int i = 0; i < glyphs.length; i += perRow) {
                                rows.add(
                                  glyphs.sublist(
                                    i,
                                    (i + perRow > glyphs.length)
                                        ? glyphs.length
                                        : i + perRow,
                                  ),
                                );
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: rows.map((row) {
                                  final rowWidth = row.length == 1
                                      ? cellWidth
                                      : cellWidth +
                                          (row.length - 1) * effectiveWidth;

                                  return SizedBox(
                                    width: rowWidth,
                                    height: cellHeight,
                                    child: Stack(
                                      clipBehavior: Clip.hardEdge,
                                      children: List.generate(row.length, (i) {
                                        final g = row[i];
                                        final left = i * effectiveWidth;

                                        return Positioned(
                                          left: left,
                                          top: 0,
                                          child: SizedBox(
                                            width: cellWidth,
                                            height: cellHeight,
                                            child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: g.id == 'SPACE'
                                                  ? const SizedBox()
                                                  : g.assetPath.isNotEmpty
                                                      ? Image.asset(
                                                          g.assetPath,
                                                        )
                                                      : Text(
                                                          g.id,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 80,
                                                          ),
                                                        ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
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
                    // Current glyph preview – tight overlap
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(currentGlyphs.length, (i) {
                            final g = currentGlyphs[i];
                            const double overlap = 18.0;

                            return Transform.translate(
                              offset: Offset(-i * overlap, 0),
                              child: SizedBox(
                                width: 46,
                                height: 46,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: g.id == 'SPACE'
                                      ? const SizedBox() // invisible gap
                                      : g.assetPath.isNotEmpty
                                          ? Image.asset(
                                              g.assetPath,
                                              color: Colors.white,
                                              colorBlendMode:
                                                  BlendMode.srcATop,
                                            )
                                          : Text(
                                              g.id,
                                              style: const TextStyle(
                                                fontSize: 32,
                                                color: Colors.white,
                                              ),
                                            ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // SEND BUTTON
                    GestureDetector(
                      onTap: currentGlyphs.isEmpty ? null : _onSendPressed,
                      child: Opacity(
                        opacity: currentGlyphs.isEmpty ? 0.3 : 1.0,
                        child: SizedBox(
                          width: 90,
                          height: 70,
                          child: Image.asset(
                            'assets/glyphs/send_button.png',
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

            // KEYBOARD AREA – custom stepped layout + space/backspace
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                const outerPadding = 24.0;
                const keyGap = 4.0;

                final row1AvailableWidth = width - 2 * outerPadding;
                final keySize = (row1AvailableWidth - 8 * keyGap) / 9;
                final slotWidth = keySize + keyGap;

                final row1 = allGlyphs.sublist(0, 9);
                final row2 = allGlyphs.sublist(9, 16);
                final row3 = allGlyphs.sublist(16, 23);
                final bottomRow = allGlyphs.sublist(23, 26);

                Widget buildGlyphKey(Glyph glyph) {
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

                Widget buildRow(List<Glyph> glyphs, double leftIndent) {
                  return Padding(
                    padding: EdgeInsets.only(left: leftIndent),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < glyphs.length; i++) ...[
                          buildGlyphKey(glyphs[i]),
                          if (i != glyphs.length - 1)
                            const SizedBox(width: keyGap),
                        ],
                      ],
                    ),
                  );
                }

                // row offsets
                final row1Left = outerPadding;
                final row2Left = outerPadding + 1 * slotWidth;
                final row3Left = outerPadding + 0.5 * slotWidth;

                // special positions for space + delete
                final spaceLeft = outerPadding + 0.5 * slotWidth;
                final deleteLeft = outerPadding + 7.5 * slotWidth;
                final bottomGlyphsLeft = outerPadding + 3.5 * slotWidth;

                // space key widget (uses your PNG)
Widget buildSpaceKey() {
  return GestureDetector(
    onTap: () {
      if (currentGlyphs.length >= 40) return;
      setState(() => currentGlyphs.add(_spaceGlyph)); // still adds invisible SPACE glyph
    },
    child: SizedBox(
      width: keySize,
      height: keySize,
      child: Image.asset(
        'assets/glyphs/space_key.png',   // 👈 your space PNG
        fit: BoxFit.contain,
      ),
    ),
  );
}

// backspace key widget (uses your PNG)
Widget buildBackspaceKey() {
  return GestureDetector(
    onTap: () {
      if (currentGlyphs.isEmpty) return;
      setState(() => currentGlyphs.removeLast());
    },
    child: SizedBox(
      width: keySize,
      height: keySize,
      child: Image.asset(
        'assets/glyphs/delete_key.png',  // 👈 your delete PNG
        fit: BoxFit.contain,
      ),
    ),
  );
}

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

                    // bottom row: glyphs + space + backspace positioned by slots
                    SizedBox(
                      height: keySize,
                      width: width,
                      child: Stack(
                        children: [
                          // 3 glyphs centered-ish
                          Positioned(
                            left: bottomGlyphsLeft,
                            top: 0,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < bottomRow.length; i++) ...[
                                  buildGlyphKey(bottomRow[i]),
                                  if (i != bottomRow.length - 1)
                                    const SizedBox(width: keyGap),
                                ],
                              ],
                            ),
                          ),

                          // space key at 0.5 slots in
                          Positioned(
                            left: spaceLeft,
                            top: 0,
                            child: buildSpaceKey(),
                          ),

                          // delete key at 7.5 slots in
                          Positioned(
                            left: deleteLeft,
                            top: 0,
                            child: buildBackspaceKey(),
                          ),
                        ],
                      ),
                    ),

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
    await printerService.printMessage(msg);

    setState(() {
      currentGlyphs.clear();
    });

    // keep the message visible for a few seconds, then fade + remove
    const visibleDuration = Duration(seconds: 4);
    const fadeDuration = Duration(milliseconds: 500);

    Future.delayed(visibleDuration, () {
      if (!mounted) return;
      setState(() {
        msg.isVisible = false;
      });

      Future.delayed(fadeDuration, () {
        if (!mounted) return;
        setState(() {
          messages.removeWhere((m) => m.id == msg.id);
        });
      });
    });
  }
}
