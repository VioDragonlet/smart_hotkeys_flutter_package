// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demo_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Demo)
final demoProvider = DemoProvider._();

final class DemoProvider extends $NotifierProvider<Demo, DemoState> {
  DemoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'demoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$demoHash();

  @$internal
  @override
  Demo create() => Demo();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DemoState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DemoState>(value),
    );
  }
}

String _$demoHash() => r'9ff601c45ca5fa093e069bdb98508d830a56c807';

abstract class _$Demo extends $Notifier<DemoState> {
  DemoState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DemoState, DemoState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DemoState, DemoState>,
              DemoState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
