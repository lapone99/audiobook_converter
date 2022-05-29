import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:first_flutter_app/domain/Book.dart';
import 'package:image/image.dart' as imglib;

Future<Book> getBookFromFile(String filename) async {
  final doc = await PdfDocument.openFile(filename);

  var page = await doc.getPage(1);
  var imgPdf = await page.render();
  ui.Image img = await imgPdf.createImageDetached();
  var imgBytes = await img.toByteData(format: ImageByteFormat.png);
  var libImage = imglib.decodeImage(imgBytes!.buffer
      .asUint8List(imgBytes.offsetInBytes, imgBytes.lengthInBytes));
  final String path = (await getApplicationDocumentsDirectory()).path;
  String pathForImage = '$path${getNameFromSourceName(doc.sourceName)}.png';

  await File(pathForImage).writeAsBytes(imglib.encodePng(libImage!));

  return Book.withUrl(
      pathForImage, getNameFromSourceName(doc.sourceName), DateTime.now());
}

String getNameFromSourceName(String sourceName) {
  return sourceName.substring(
      sourceName.lastIndexOf('/'), sourceName.lastIndexOf('.'));
}
