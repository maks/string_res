A Dart Builder for creating a class with String constants from a JSON file.


## Usage

If using with json in assets folder need a build.yaml in *your* flutter app eg:

```yaml
targets:
    $default:
      sources:            
        - assets/I10n/en_US.json

```

For Flutter run using standard command:
`flutter packages pub run build_runner build`

or with the new [hot-reload code-gen builder support](https://github.com/flutter/flutter/wiki/Code-generation-in-Flutter)

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/maks/string_res/issues
