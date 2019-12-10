// Copyright 2019 Jonah Williams. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:meta/meta.dart';

/// A builder which outputs strings constants from json.
class StringResourceBuilder implements Builder {
  const StringResourceBuilder();

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    /// Read the input source and parse it as JSON.
    Map<String, Object> source;
    final outputId = buildStep.inputId.changeExtension('.dart');
    try {
      source = json.decode(await buildStep.readAsString(buildStep.inputId))
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
    await buildStep.writeAsString(outputId, outputString);
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        '.json': ['.dart']
      };
}

@visibleForTesting
class StringConstGenerator {
  static const MAX_VALUE_COMMENT_LENGTH = 50;

  const StringConstGenerator();

  void makeResource(Map<String, Object> body, StringBuffer buffer) {
    body.keys.forEach((key) {
      final value =
          body[key].toString().replaceAll(RegExp(r"\n", multiLine: true), ' ');
      final commentLength = min(MAX_VALUE_COMMENT_LENGTH, value.length);
      final truncated = commentLength == MAX_VALUE_COMMENT_LENGTH ? '...' : '';
      buffer.write('// ${value.substring(0, commentLength)}$truncated\n');
      buffer.write('static const ${key.toUpperCase()} = "$key";\n');
    });
  }
}
