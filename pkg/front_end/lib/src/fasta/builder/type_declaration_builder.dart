// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library fasta.type_declaration_builder;

import 'package:kernel/ast.dart' show DartType, Nullability;

import 'builder.dart';
import 'library_builder.dart';
import 'metadata_builder.dart';
import 'modifier_builder.dart';
import 'nullability_builder.dart';
import 'type_builder.dart';

abstract class TypeDeclarationBuilder implements ModifierBuilder {
  @override
  String get name;

  bool get isNamedMixinApplication;

  void set parent(Builder? value);

  List<MetadataBuilder>? get metadata;

  int get typeVariablesCount => 0;

  @override
  TypeDeclarationBuilder get origin;

  /// Creates the [DartType] corresponding to this declaration applied with
  /// [arguments] in [library] with the syntactical nullability defined by
  /// [nullabilityBuilder].
  ///
  /// For instance, if this declaration is a class declaration `C`, then
  /// an occurrence of `C<int>?` in a null safe library `lib1` would call
  /// `buildType(<lib1>, <?>, [<int>])` to create `C<int>?`, or `C<int>` in a
  /// legacy library `lib2` call `buildType(<lib2>, <> [<int>]` to create
  /// `C<int*>*`.
  DartType buildType(LibraryBuilder library,
      NullabilityBuilder nullabilityBuilder, List<TypeBuilder>? arguments);

  DartType buildTypeLiteralType(LibraryBuilder library,
      NullabilityBuilder nullabilityBuilder, List<TypeBuilder>? arguments);

  /// [arguments] have already been built.
  DartType buildTypeWithBuiltArguments(LibraryBuilder library,
      Nullability nullability, List<DartType> arguments);
}

abstract class TypeDeclarationBuilderImpl extends ModifierBuilderImpl
    implements TypeDeclarationBuilder {
  @override
  final List<MetadataBuilder>? metadata;

  @override
  final int modifiers;

  @override
  final String name;

  TypeDeclarationBuilderImpl(
      this.metadata, this.modifiers, this.name, Builder? parent, int charOffset)
      // ignore: unnecessary_null_comparison
      : assert(modifiers != null),
        super(parent, charOffset);

  @override
  TypeDeclarationBuilder get origin => this;

  @override
  bool get isNamedMixinApplication => false;

  @override
  bool get isTypeDeclaration => true;

  @override
  String get fullNameForErrors => name;

  @override
  int get typeVariablesCount => 0;

  @override
  DartType buildTypeLiteralType(LibraryBuilder library,
      NullabilityBuilder nullabilityBuilder, List<TypeBuilder>? arguments) {
    return buildType(library, nullabilityBuilder, arguments);
  }
}
