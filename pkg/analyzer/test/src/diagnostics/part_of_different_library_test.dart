// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/src/error/codes.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../dart/resolution/context_collection_resolution.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PartOfDifferentLibraryTest);
  });
}

@reflectiveTest
class PartOfDifferentLibraryTest extends PubPackageResolutionTest {
  test_name() async {
    newFile2('$testPackageLibPath/part.dart', "part of lub;");
    await assertErrorsInCode('''
library lib;
part 'part.dart';
''', [
      error(CompileTimeErrorCode.PART_OF_DIFFERENT_LIBRARY, 18, 11),
    ]);
  }
}
