import 'dart:io';
import 'dart:convert';
import 'strings.dart';

Future<void> main() async {
  // expect current dir to be top-level of this package
  final file = File('assets/data/strings.json');
  final data = json.decode(await file.readAsString());
  print('foo value is: ${data[SR.FOO]}');
}
