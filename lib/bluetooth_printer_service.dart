import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'glyph.dart';
import 'printer_service.dart';

class BluetoothPrinterService implements PrinterService {
  BluetoothPrinterService();

  @override
  Future<void> printMessage(Message message) async {
    // TODO: 1) render glyphs to image
    //       2) send image to bluetooth printer
    // For now, just log so app still works:
    // ignore: avoid_print
    print('BLUETOOTH PRINT (stub): ${message.id} '
          'with ${message.glyphs.length} glyphs');
  }

  /// Example of how you'll render the message to an image.
  /// (We'll use this later when adding the real plugin.)
  Future<Uint8List> renderMessageToImage(Message message) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    // You can tweak these sizes later based on printer width.
    const double width = 384; // common thermal printer width in px
    const double height = 200;

    final paint = Paint()..color = Colors.white;
    canvas.drawRect(const Rect.fromLTWH(0, 0, width, height), paint);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // For now, just render IDs as text; later we can render actual PNG glyphs.
    final text = message.glyphs.map((g) => g.id).join(' ');
    textPainter.text = TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
      ),
    );

    textPainter.layout(maxWidth: width - 40);
    textPainter.paint(canvas, const Offset(20, 80));

    final picture = recorder.endRecording();
    final img = await picture.toImage(width.toInt(), height.toInt());
    final bytes = await img.toByteData(format: ImageByteFormat.png);

    return bytes!.buffer.asUint8List();
  }
}
