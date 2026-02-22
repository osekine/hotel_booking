// @dart=3.6
// ignore_for_file: directives_ordering
// build_runner >=2.4.16
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:build_runner_core/build_runner_core.dart' as _i1;
import 'package:graphql_codegen/builder.dart' as _i2;
import 'dart:isolate' as _i3;
import 'package:build_runner/src/build_script_generate/build_process_state.dart'
    as _i4;
import 'package:build_runner/build_runner.dart' as _i5;
import 'dart:io' as _i6;

final _builders = <_i1.BuilderApplication>[
  _i1.apply(
    r'graphql_codegen:graphql_codegen',
    [_i2.GraphQLBuilder.builder],
    _i1.toDependentsOf(r'graphql_codegen'),
    hideOutput: false,
  )
];
void main(
  List<String> args, [
  _i3.SendPort? sendPort,
]) async {
  await _i4.buildProcessState.receive(sendPort);
  _i4.buildProcessState.isolateExitCode = await _i5.run(
    args,
    _builders,
  );
  _i6.exitCode = _i4.buildProcessState.isolateExitCode!;
  await _i4.buildProcessState.send(sendPort);
}
