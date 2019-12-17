A Dart Builder for creating a class with String constants from a JSON file.


## Usage

JSON file **MUST** be named `strings.json` and live somewhere within the `assets` top-level folder of your Flutter app project.

The JSON file is expected to have a single top-level object whose properties will be used in the output.

The output will create a Class named `SR` in `lib/strings.dart` which will contain a static String constant for every property found in the top-level JSON object.

For Flutter run using standard command:
`flutter packages pub run build_runner build`

or with the new [hot-reload code-gen builder support](https://github.com/flutter/flutter/wiki/Code-generation-in-Flutter)

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/maks/string_res/issues
