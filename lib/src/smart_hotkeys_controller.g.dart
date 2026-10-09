// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_hotkeys_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// One controller per Flutter engine. Access through [smartHotkeysProvider].

@ProviderFor(SmartHotkeys)
final smartHotkeysProvider = SmartHotkeysProvider._();

/// One controller per Flutter engine. Access through [smartHotkeysProvider].
final class SmartHotkeysProvider
    extends $NotifierProvider<SmartHotkeys, HotkeysState> {
  /// One controller per Flutter engine. Access through [smartHotkeysProvider].
  SmartHotkeysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'smartHotkeysProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$smartHotkeysHash();

  @$internal
  @override
  SmartHotkeys create() => SmartHotkeys();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HotkeysState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HotkeysState>(value),
    );
  }
}

String _$smartHotkeysHash() => r'02da359ee3a9ca69231ad6a015590dafb47e39c2';

/// One controller per Flutter engine. Access through [smartHotkeysProvider].

abstract class _$SmartHotkeys extends $Notifier<HotkeysState> {
  HotkeysState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<HotkeysState, HotkeysState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HotkeysState, HotkeysState>,
              HotkeysState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
