// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:test_runner/src/configuration.dart';
import 'package:test_runner/src/options.dart';
import 'package:test_runner/src/path.dart';
import 'package:test_runner/src/static_error.dart';
import 'package:test_runner/src/test_file.dart';
import 'package:test_runner/src/test_suite.dart';

TestFile parseTestFile(String source,
    {String path = "some_test.dart", String suite = "language"}) {
  final suiteDirectory = Path(suite);
  path = suiteDirectory.absolute.append(path).toNativePath();
  return TestFile.parse(suiteDirectory.absolute, path, source);
}

// TODO(rnystrom): Would be nice if there was a simpler way to create a
// configuration for use in unit tests.
TestConfiguration makeConfiguration(List<String> arguments, String suite) {
  return OptionsParser().parse([...arguments, suite]).first;
}

/// Creates a [StandardTestSuite] hardcoded to contain [testFiles].
StandardTestSuite makeTestSuite(TestConfiguration configuration,
        List<TestFile> testFiles, String suite) =>
    _MockTestSuite(configuration, testFiles, suite);

/// Creates a [StaticError].
///
/// Only one of [analyzerError], [cfeError], or [webError] may be passed.
StaticError makeError(
    {int line = 1,
    int column = 2,
    int length,
    String analyzerError,
    String cfeError,
    String webError}) {
  if (analyzerError != null) {
    assert(cfeError == null && webError == null);
    return StaticError(ErrorSource.analyzer, analyzerError,
        line: line, column: column, length: length);
  } else if (cfeError != null) {
    assert(webError == null);
    return StaticError(ErrorSource.cfe, cfeError,
        line: line, column: column, length: length);
  } else {
    assert(webError != null);
    return StaticError(ErrorSource.web, webError,
        line: line, column: column, length: length);
  }
}

class _MockTestSuite extends StandardTestSuite {
  final List<TestFile> _testFiles;

  _MockTestSuite(TestConfiguration configuration, this._testFiles, String suite)
      : super(configuration, suite, Path(suite), []);

  @override
  Iterable<TestFile> findTests() => _testFiles;
}
