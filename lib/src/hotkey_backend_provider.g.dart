// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotkey_backend_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(hotkeyBackend)
final hotkeyBackendProvider = HotkeyBackendProvider._();

final class HotkeyBackendProvider
    extends $FunctionalProvider<HotkeyBackend, HotkeyBackend, HotkeyBackend>
    with $Provider<HotkeyBackend> {
  HotkeyBackendProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hotkeyBackendProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hotkeyBackendHash();

  @$internal
  @override
  $ProviderElement<HotkeyBackend> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HotkeyBackend create(Ref ref) {
    return hotkeyBackend(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HotkeyBackend value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HotkeyBackend>(value),
    );
  }
}

String _$hotkeyBackendHash() => r'14c27251236f69b60efecb946f3a9714a9cdc6aa';
