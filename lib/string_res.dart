/// Builder for generating string constants
library string_res;

import 'package:build/build.dart';
import 'src/builder.dart';

/// Creates a [StringResourceBuilder]
Builder stringResourceBuilder(BuilderOptions builderOptions) =>
    const StringResourceBuilder();
