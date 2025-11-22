import 'glyph.dart';

/// Abstract printer service – allows us to swap implementation later.
abstract class PrinterService {
  Future<void> printMessage(Message message);
}

/// For development: does NOT talk to a real printer, just logs.
class DebugPrinterService implements PrinterService {
  @override
  Future<void> printMessage(Message message) async {
    // Here we just log to console.
    // Later we will replace this with a BluetoothPrinterService.
    // ignore: avoid_print
    print('PRINT MESSAGE (DEBUG): ${message.id} '
        'with ${message.glyphs.length} glyphs');
  }
}

// 👉 Use the debug printer for now so everything compiles & runs
final PrinterService printerService = DebugPrinterService();
