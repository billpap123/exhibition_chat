import 'package:flutter/material.dart';
import 'glyph.dart';
import 'printer_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Keep spacing identical between black bar preview and bubble
  static const double kOverlap = 22.0; // bigger = more overlap = tighter
  static const int kMaxGlyphs = 120; // choose your limit

  // Black bar preview sizing
  static const double kPreviewSize = 46.0; // size of glyphs in the black bar

  // The horizontal "step" between glyphs (this is the spacing rule)
  static const double kStep = kPreviewSize - kOverlap; // 24.0

  // Bubble glyph size (big)
  static const double kBubbleGlyphSize = 80.0;

  // SPACE width multiplier (step-based)
  static const double kSpaceMultiplier = 1.6;

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
  final ScrollController _previewScrollController = ScrollController();

  // special glyph for space (no image, invisible)
  Glyph get _spaceGlyph => Glyph(id: 'SPACE', assetPath: '');

  double _previewStepFor(Glyph g) =>
      g.id == 'SPACE' ? kStep * kSpaceMultiplier : kStep;

  double _bubbleStepFor(Glyph g) {
    final double scale = kBubbleGlyphSize / kPreviewSize;
    return _previewStepFor(g) * scale;
  }

  void _scrollPreviewToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_previewScrollController.hasClients) return;
      _previewScrollController.jumpTo(
        _previewScrollController.position.maxScrollExtent,
      );
    });
  }

  /// Total scrollable width for the black-bar preview content.
  /// width = first glyph full width + sum(steps of all glyphs except last)
  double _previewContentWidth(List<Glyph> glyphs) {
    if (glyphs.isEmpty) return 0;
    double w = kPreviewSize;
    for (int i = 0; i < glyphs.length - 1; i++) {
      w += _previewStepFor(glyphs[i]);
    }
    return w;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _previewScrollController.dispose();
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

                              const double cellWidth = kBubbleGlyphSize;
                              const double cellHeight = kBubbleGlyphSize;

                              // average step to estimate perRow
                              final double avgStep =
                                  (_bubbleStepFor(_spaceGlyph) + _bubbleStepFor(Glyph(id: 'X', assetPath: ''))) /
                                      2;

                              int perRow =
                                  (constraints.maxWidth / avgStep).floor();
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
                                  // row width = first glyph full width + sum(steps of glyphs except last)
                                  double rowWidth = row.isEmpty ? 0 : cellWidth;
                                  for (int i = 0; i < row.length - 1; i++) {
                                    rowWidth += _bubbleStepFor(row[i]);
                                  }

                                  return SizedBox(
                                    width: rowWidth,
                                    height: cellHeight,
                                    child: Stack(
                                      clipBehavior: Clip.hardEdge,
                                      children: List.generate(row.length, (i) {
                                        double left = 0;
                                        for (int j = 0; j < i; j++) {
                                          left += _bubbleStepFor(row[j]);
                                        }

                                        final g = row[i];

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
                                                      ? Image.asset(g.assetPath)
                                                      : Text(
                                                          g.id,
                                                          style: const TextStyle(
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
                    // Current glyph preview – stepped layout + variable SPACE
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _previewScrollController,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        child: SizedBox(
                          width: _previewContentWidth(currentGlyphs),
                          height: kPreviewSize,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              for (int i = 0; i < currentGlyphs.length; i++)
                                Positioned(
                                  left: (() {
                                    double x = 0;
                                    for (int j = 0; j < i; j++) {
                                      x += _previewStepFor(currentGlyphs[j]);
                                    }
                                    return x;
                                  })(),
                                  top: 0,
                                  child: SizedBox(
                                    width: currentGlyphs[i].id == 'SPACE'
                                        ? kPreviewSize * kSpaceMultiplier
                                        : kPreviewSize,
                                    height: kPreviewSize,
                                    child: currentGlyphs[i].id == 'SPACE'
                                        ? const SizedBox()
                                        : FittedBox(
                                            fit: BoxFit.contain,
                                            child: Image.asset(
                                              currentGlyphs[i].assetPath,
                                              color: Colors.white,
                                              colorBlendMode: BlendMode.srcATop,
                                            ),
                                          ),
                                  ),
                                ),
                            ],
                          ),
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

                final row1AvailableWidth =
                    (width - 2 * outerPadding).clamp(0.0, double.infinity);

                final rawKeySize = (row1AvailableWidth - 8 * keyGap) / 9;

                // Prevent negative/too-small sizes (this is what crashes on the tablet)
                final keySize = rawKeySize.clamp(24.0, 120.0);
                final slotWidth = keySize + keyGap;

                final row1 = allGlyphs.sublist(0, 9);
                final row2 = allGlyphs.sublist(9, 16);
                final row3 = allGlyphs.sublist(16, 23);
                final bottomRow = allGlyphs.sublist(23, 26);

                Widget buildGlyphKey(Glyph glyph) {
                  return GestureDetector(
                    onTap: () {
                      if (currentGlyphs.length >= kMaxGlyphs) return;
                      setState(() => currentGlyphs.add(glyph));
                      _scrollPreviewToEnd();
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
                      if (currentGlyphs.length >= kMaxGlyphs) return;
                      setState(() => currentGlyphs.add(_spaceGlyph));
                      _scrollPreviewToEnd();
                    },
                    child: SizedBox(
                      width: keySize,
                      height: keySize,
                      child: Image.asset(
                        'assets/glyphs/space_key.png',
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
                      _scrollPreviewToEnd();
                    },
                    child: SizedBox(
                      width: keySize,
                      height: keySize,
                      child: Image.asset(
                        'assets/glyphs/delete_key.png',
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
