/// Domain model for a user-created custom list.
///
/// Custom lists are persisted under `/user/{uid}/list/{listId}` with
/// `type: "custom"` to distinguish from system lists (watched, watchlist, favorites).
///
/// The domain model contains only the essential fields for the feature.
/// Firestore persistence includes additional metadata (createdAt, updatedAt).
class UserCustomList {
  UserCustomList({
    required this.id,
    required this.name,
    required this.iconName,
    this.createdAt,
    this.updatedAt,
  });

  /// Firestore document ID (auto-generated or UUID).
  final String id;

  /// User-defined name for the list (1–30 characters).
  final String name;

  /// Icon identifier key in [listIconCatalog].
  /// Persisted as a string to enable icon changes across app versions.
  final String iconName;

  /// Timestamp when the list was created.
  /// Set by Firestore serverTimestamp.
  final DateTime? createdAt;

  /// Timestamp when the list was last updated.
  /// Set by Firestore serverTimestamp.
  final DateTime? updatedAt;

  /// Factory constructor from Firestore document data.
  factory UserCustomList.fromFirestore(String id, Map<String, dynamic> data) {
    return UserCustomList(
      id: id,
      name: data['name'] as String? ?? '',
      iconName: data['iconName'] as String? ?? 'bookmark_outline',
      createdAt: (data['createdAt'] as dynamic)?.toDate() as DateTime?,
      updatedAt: (data['updatedAt'] as dynamic)?.toDate() as DateTime?,
    );
  }

  /// Convert to Firestore-compatible map.
  /// Includes type field and timestamps for persistence.
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'type': 'custom',
      'iconName': iconName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCustomList &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          iconName == other.iconName &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      iconName.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;

  @override
  String toString() =>
      'UserCustomList(id: $id, name: $name, iconName: $iconName, '
      'createdAt: $createdAt, updatedAt: $updatedAt)';
}
