/// Editable profile fields owned by the user document.
class ProfileUpdate {
  const ProfileUpdate({this.username, this.avatarUrl});

  final String? username;
  final String? avatarUrl;

  Map<String, Object?> toFirestoreUpdate() {
    return {
      if (username != null) 'username': username!.trim(),
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
    };
  }
}
