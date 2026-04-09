/// Immutable region item displayed in the region selector.
///
/// Uses a 2-letter ISO-3166 alpha-2 [code] and its corresponding [flagEmoji]
/// to present concise options in dropdown-based UIs.
class RegionOption {
  const RegionOption({required this.code, required this.flagEmoji});

  /// Two-letter ISO-3166 alpha-2 code (for example: `US`, `MX`, `ES`).
  final String code;

  /// Emoji flag rendered alongside [code] in selection UIs.
  final String flagEmoji;
}
