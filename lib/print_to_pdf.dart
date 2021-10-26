library html2pdf;

import 'dart:io';
import 'package:puppeteer/puppeteer.dart';
import 'package:sprintf/sprintf.dart';

void makeAllPagesToPdf(
    {required String url,
    required List<String> pages,
    required String jscode,
    required String output}) async {
  // Start the browser and go to a web page
  var browser = await puppeteer.launch();

  var pdfnames = <String>[];
  int index = 0;
  for (int i = 0; i < pages.length; i++) {
    if (index == pages.length - 1) break;
    final name = sprintf('%03d.pdf', [index++]);
    pdfnames.add(name);
    await makePdf(browser, '$url/${pages[index]}', name, jscode);
  }

  var args = [
    'merge',
    '-m',
    'create',
    '-s',
    output,
  ];

  args.addAll(pdfnames);

  var result = await Process.run('pdfcpu', args);
  stdout.write(result.stdout);
  stderr.write(result.stderr);

  await browser.close();
}

Future<void> makePdf(
    Browser browser, String url, String name, String jscode) async {
  var page = await browser.newPage();
  await page.goto(url, wait: Until.networkIdle);

  // For this example, we force the "screen" media-type because sometime
  // CSS rules with "@media print" can change the look of the page.
  await page.emulateMediaType(MediaType.screen);

  await page.evaluate(jscode);

  // Capture the PDF and save it to a file.
  await page.pdf(
      format: PaperFormat.a4,
      printBackground: true,
      output: File(name).openWrite());
}
