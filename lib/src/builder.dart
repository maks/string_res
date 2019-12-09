// Copyright 2019 Jonah Williams. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

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
      print("PARSING: ${buildStep.inputId}");
      source = json.decode(await buildStep.readAsString(buildStep.inputId))
          as Map<String, Object>;
    } catch (err) {
      source = {
        'name': 'Text',
        'params': {
          '0': 'Error: invalid json',
        },
      };
    }
    final output = StringBuffer();
    // write the header.
    output.write('class SR {');
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
    print("OUTPUT:\n $outputString");
    await buildStep.writeAsString(outputId, outputString);
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        '.json': ['.dart']
      };
}

@visibleForTesting
class StringConstGenerator {
  const StringConstGenerator();

  void makeResource(Map<String, Object> body, StringBuffer buffer) {
    body.keys.forEach((key) {
      buffer.write('static const ${key.toUpperCase()} = "$key";\n');
    });
  }
}
