import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:glob/glob.dart';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

/// A builder which outputs a Dart Class containing String constants for
/// all the keys in the given JSON file
/// The JSON file is assumed to have a single top-level object whose properties
/// will be used in the output Strings constants
/// The JSON file MUST be named `strings.json` and be found somewhere within the
/// top-level Flutter assets folder
class StringResourceBuilder implements Builder {
  const StringResourceBuilder();
  static const OUTPUT_FILENAME = 'strings.dart';
  static final _allFilesInLib = Glob('assets/**/strings.json');

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final files = <String>[];
    AssetId inputId;
    await for (final input in buildStep.findAssets(_allFilesInLib)) {
      files.add(input.path);
      inputId = input;
    }

    // Read the input source and parse it as JSON.
    Map<String, Object> source;
    try {
      source = json.decode(await buildStep.readAsString(inputId))
          as Map<String, Object>;
    } catch (err) {
      source = {};
    }
    final output = StringBuffer();
    // write the header.
    output.write('''
    /// This is a auto-generated file DO NOT edit.
    class SR {
    ''');
    StringConstGenerator().makeResource(source, output);

    // write the footer.
    output.write('}');

    // Write the results to disk and format it.
    String outputString;
    // Always output something to keep hot reload working.
    try {
      outputString = DartFormatter().format(output.toString()).toString();
    } catch (err) {
      outputString = err.toString();
    }
    final outputId = _allFileOutput(buildStep);
    return buildStep.writeAsString(outputId, outputString);
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        r'$lib$': <String>[OUTPUT_FILENAME]
      };

  static AssetId _allFileOutput(BuildStep buildStep) {
    return AssetId(
        buildStep.inputId.package, path.join('lib', OUTPUT_FILENAME));
  }
}

@visibleForTesting
class StringConstGenerator {
  static const MAX_VALUE_COMMENT_LENGTH = 50;

  const StringConstGenerator();

  void makeResource(Map<String, Object> body, StringBuffer buffer) {
    body.keys.forEach((key) {
      final value =
          body[key].toString().replaceAll(RegExp(r'\n', multiLine: true), ' ');
      final commentLength = min(MAX_VALUE_COMMENT_LENGTH, value.length);
      final truncated = commentLength == MAX_VALUE_COMMENT_LENGTH ? '...' : '';
      buffer.write('// ${value.substring(0, commentLength)}$truncated\n');
      buffer.write('static const ${key.toUpperCase()} = "$key";\n');
    });
  }
}
