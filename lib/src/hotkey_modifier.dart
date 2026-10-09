/// Left and right variants are treated as the same modifier.
enum HotkeyModifier {
  control(1, 'Ctrl'),
  alt(2, 'Alt'),
  shift(4, 'Shift'),
  meta(8, 'Meta');

  const HotkeyModifier(this.mask, this.label);
  final int mask;
  final String label;
}
