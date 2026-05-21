// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $UsersTableTable extends UsersTable
    with TableInfo<$UsersTableTable, UserLocalEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uid,
    email,
    username,
    avatarUrl,
    updatedAt,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserLocalEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uid};
  @override
  UserLocalEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserLocalEntity(
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $UsersTableTable createAlias(String alias) {
    return $UsersTableTable(attachedDatabase, alias);
  }
}

class UserLocalEntity extends DataClass implements Insertable<UserLocalEntity> {
  final String uid;
  final String email;
  final String username;
  final String? avatarUrl;
  final DateTime updatedAt;
  final DateTime cachedAt;
  const UserLocalEntity({
    required this.uid,
    required this.email,
    required this.username,
    this.avatarUrl,
    required this.updatedAt,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uid'] = Variable<String>(uid);
    map['email'] = Variable<String>(email);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  UsersTableCompanion toCompanion(bool nullToAbsent) {
    return UsersTableCompanion(
      uid: Value(uid),
      email: Value(email),
      username: Value(username),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      updatedAt: Value(updatedAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory UserLocalEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserLocalEntity(
      uid: serializer.fromJson<String>(json['uid']),
      email: serializer.fromJson<String>(json['email']),
      username: serializer.fromJson<String>(json['username']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uid': serializer.toJson<String>(uid),
      'email': serializer.toJson<String>(email),
      'username': serializer.toJson<String>(username),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  UserLocalEntity copyWith({
    String? uid,
    String? email,
    String? username,
    Value<String?> avatarUrl = const Value.absent(),
    DateTime? updatedAt,
    DateTime? cachedAt,
  }) => UserLocalEntity(
    uid: uid ?? this.uid,
    email: email ?? this.email,
    username: username ?? this.username,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    updatedAt: updatedAt ?? this.updatedAt,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  UserLocalEntity copyWithCompanion(UsersTableCompanion data) {
    return UserLocalEntity(
      uid: data.uid.present ? data.uid.value : this.uid,
      email: data.email.present ? data.email.value : this.email,
      username: data.username.present ? data.username.value : this.username,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserLocalEntity(')
          ..write('uid: $uid, ')
          ..write('email: $email, ')
          ..write('username: $username, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(uid, email, username, avatarUrl, updatedAt, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserLocalEntity &&
          other.uid == this.uid &&
          other.email == this.email &&
          other.username == this.username &&
          other.avatarUrl == this.avatarUrl &&
          other.updatedAt == this.updatedAt &&
          other.cachedAt == this.cachedAt);
}

class UsersTableCompanion extends UpdateCompanion<UserLocalEntity> {
  final Value<String> uid;
  final Value<String> email;
  final Value<String> username;
  final Value<String?> avatarUrl;
  final Value<DateTime> updatedAt;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const UsersTableCompanion({
    this.uid = const Value.absent(),
    this.email = const Value.absent(),
    this.username = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersTableCompanion.insert({
    required String uid,
    required String email,
    required String username,
    this.avatarUrl = const Value.absent(),
    required DateTime updatedAt,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : uid = Value(uid),
       email = Value(email),
       username = Value(username),
       updatedAt = Value(updatedAt),
       cachedAt = Value(cachedAt);
  static Insertable<UserLocalEntity> custom({
    Expression<String>? uid,
    Expression<String>? email,
    Expression<String>? username,
    Expression<String>? avatarUrl,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uid != null) 'uid': uid,
      if (email != null) 'email': email,
      if (username != null) 'username': username,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersTableCompanion copyWith({
    Value<String>? uid,
    Value<String>? email,
    Value<String>? username,
    Value<String?>? avatarUrl,
    Value<DateTime>? updatedAt,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return UsersTableCompanion(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableCompanion(')
          ..write('uid: $uid, ')
          ..write('email: $email, ')
          ..write('username: $username, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserListsTableTable extends UserListsTable
    with TableInfo<$UserListsTableTable, UserListLocalEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserListsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<String> listId = GeneratedColumn<String>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    listId,
    uid,
    name,
    type,
    iconName,
    createdAt,
    updatedAt,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_lists_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserListLocalEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {listId};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {uid, listId},
  ];
  @override
  UserListLocalEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserListLocalEntity(
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_id'],
      )!,
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $UserListsTableTable createAlias(String alias) {
    return $UserListsTableTable(attachedDatabase, alias);
  }
}

class UserListLocalEntity extends DataClass
    implements Insertable<UserListLocalEntity> {
  final String listId;
  final String uid;
  final String name;

  /// Type of list: 'watched', 'watchlist', 'favorites', or 'custom'
  final String type;
  final String? iconName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime cachedAt;
  const UserListLocalEntity({
    required this.listId,
    required this.uid,
    required this.name,
    required this.type,
    this.iconName,
    this.createdAt,
    this.updatedAt,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['list_id'] = Variable<String>(listId);
    map['uid'] = Variable<String>(uid);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  UserListsTableCompanion toCompanion(bool nullToAbsent) {
    return UserListsTableCompanion(
      listId: Value(listId),
      uid: Value(uid),
      name: Value(name),
      type: Value(type),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory UserListLocalEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserListLocalEntity(
      listId: serializer.fromJson<String>(json['listId']),
      uid: serializer.fromJson<String>(json['uid']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'listId': serializer.toJson<String>(listId),
      'uid': serializer.toJson<String>(uid),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'iconName': serializer.toJson<String?>(iconName),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  UserListLocalEntity copyWith({
    String? listId,
    String? uid,
    String? name,
    String? type,
    Value<String?> iconName = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    DateTime? cachedAt,
  }) => UserListLocalEntity(
    listId: listId ?? this.listId,
    uid: uid ?? this.uid,
    name: name ?? this.name,
    type: type ?? this.type,
    iconName: iconName.present ? iconName.value : this.iconName,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  UserListLocalEntity copyWithCompanion(UserListsTableCompanion data) {
    return UserListLocalEntity(
      listId: data.listId.present ? data.listId.value : this.listId,
      uid: data.uid.present ? data.uid.value : this.uid,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserListLocalEntity(')
          ..write('listId: $listId, ')
          ..write('uid: $uid, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('iconName: $iconName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    listId,
    uid,
    name,
    type,
    iconName,
    createdAt,
    updatedAt,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserListLocalEntity &&
          other.listId == this.listId &&
          other.uid == this.uid &&
          other.name == this.name &&
          other.type == this.type &&
          other.iconName == this.iconName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.cachedAt == this.cachedAt);
}

class UserListsTableCompanion extends UpdateCompanion<UserListLocalEntity> {
  final Value<String> listId;
  final Value<String> uid;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> iconName;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const UserListsTableCompanion({
    this.listId = const Value.absent(),
    this.uid = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.iconName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserListsTableCompanion.insert({
    required String listId,
    required String uid,
    required String name,
    required String type,
    this.iconName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : listId = Value(listId),
       uid = Value(uid),
       name = Value(name),
       type = Value(type),
       cachedAt = Value(cachedAt);
  static Insertable<UserListLocalEntity> custom({
    Expression<String>? listId,
    Expression<String>? uid,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? iconName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (listId != null) 'list_id': listId,
      if (uid != null) 'uid': uid,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (iconName != null) 'icon_name': iconName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserListsTableCompanion copyWith({
    Value<String>? listId,
    Value<String>? uid,
    Value<String>? name,
    Value<String>? type,
    Value<String?>? iconName,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return UserListsTableCompanion(
      listId: listId ?? this.listId,
      uid: uid ?? this.uid,
      name: name ?? this.name,
      type: type ?? this.type,
      iconName: iconName ?? this.iconName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (listId.present) {
      map['list_id'] = Variable<String>(listId.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserListsTableCompanion(')
          ..write('listId: $listId, ')
          ..write('uid: $uid, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('iconName: $iconName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedMoviesTableTable extends CachedMoviesTable
    with TableInfo<$CachedMoviesTableTable, CachedMoviesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedMoviesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _movieIdMeta = const VerificationMeta(
    'movieId',
  );
  @override
  late final GeneratedColumn<int> movieId = GeneratedColumn<int>(
    'movie_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posterPathMeta = const VerificationMeta(
    'posterPath',
  );
  @override
  late final GeneratedColumn<String> posterPath = GeneratedColumn<String>(
    'poster_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _overviewMeta = const VerificationMeta(
    'overview',
  );
  @override
  late final GeneratedColumn<String> overview = GeneratedColumn<String>(
    'overview',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _releaseDateMeta = const VerificationMeta(
    'releaseDate',
  );
  @override
  late final GeneratedColumn<String> releaseDate = GeneratedColumn<String>(
    'release_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genresJsonMeta = const VerificationMeta(
    'genresJson',
  );
  @override
  late final GeneratedColumn<String> genresJson = GeneratedColumn<String>(
    'genres_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    movieId,
    title,
    posterPath,
    overview,
    releaseDate,
    genresJson,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_movies_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedMoviesData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('movie_id')) {
      context.handle(
        _movieIdMeta,
        movieId.isAcceptableOrUnknown(data['movie_id']!, _movieIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('poster_path')) {
      context.handle(
        _posterPathMeta,
        posterPath.isAcceptableOrUnknown(data['poster_path']!, _posterPathMeta),
      );
    }
    if (data.containsKey('overview')) {
      context.handle(
        _overviewMeta,
        overview.isAcceptableOrUnknown(data['overview']!, _overviewMeta),
      );
    }
    if (data.containsKey('release_date')) {
      context.handle(
        _releaseDateMeta,
        releaseDate.isAcceptableOrUnknown(
          data['release_date']!,
          _releaseDateMeta,
        ),
      );
    }
    if (data.containsKey('genres_json')) {
      context.handle(
        _genresJsonMeta,
        genresJson.isAcceptableOrUnknown(data['genres_json']!, _genresJsonMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {movieId};
  @override
  CachedMoviesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedMoviesData(
      movieId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}movie_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      posterPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_path'],
      ),
      overview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}overview'],
      ),
      releaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}release_date'],
      ),
      genresJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genres_json'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedMoviesTableTable createAlias(String alias) {
    return $CachedMoviesTableTable(attachedDatabase, alias);
  }
}

class CachedMoviesData extends DataClass
    implements Insertable<CachedMoviesData> {
  final int movieId;
  final String title;
  final String? posterPath;
  final String? overview;

  /// ISO format date string, e.g., "2023-12-15"
  final String? releaseDate;

  /// JSON array of genre objects: [{"id": 1, "name": "Action"}, ...]
  final String? genresJson;
  final DateTime cachedAt;
  const CachedMoviesData({
    required this.movieId,
    required this.title,
    this.posterPath,
    this.overview,
    this.releaseDate,
    this.genresJson,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['movie_id'] = Variable<int>(movieId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || posterPath != null) {
      map['poster_path'] = Variable<String>(posterPath);
    }
    if (!nullToAbsent || overview != null) {
      map['overview'] = Variable<String>(overview);
    }
    if (!nullToAbsent || releaseDate != null) {
      map['release_date'] = Variable<String>(releaseDate);
    }
    if (!nullToAbsent || genresJson != null) {
      map['genres_json'] = Variable<String>(genresJson);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedMoviesTableCompanion toCompanion(bool nullToAbsent) {
    return CachedMoviesTableCompanion(
      movieId: Value(movieId),
      title: Value(title),
      posterPath: posterPath == null && nullToAbsent
          ? const Value.absent()
          : Value(posterPath),
      overview: overview == null && nullToAbsent
          ? const Value.absent()
          : Value(overview),
      releaseDate: releaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseDate),
      genresJson: genresJson == null && nullToAbsent
          ? const Value.absent()
          : Value(genresJson),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedMoviesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedMoviesData(
      movieId: serializer.fromJson<int>(json['movieId']),
      title: serializer.fromJson<String>(json['title']),
      posterPath: serializer.fromJson<String?>(json['posterPath']),
      overview: serializer.fromJson<String?>(json['overview']),
      releaseDate: serializer.fromJson<String?>(json['releaseDate']),
      genresJson: serializer.fromJson<String?>(json['genresJson']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'movieId': serializer.toJson<int>(movieId),
      'title': serializer.toJson<String>(title),
      'posterPath': serializer.toJson<String?>(posterPath),
      'overview': serializer.toJson<String?>(overview),
      'releaseDate': serializer.toJson<String?>(releaseDate),
      'genresJson': serializer.toJson<String?>(genresJson),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedMoviesData copyWith({
    int? movieId,
    String? title,
    Value<String?> posterPath = const Value.absent(),
    Value<String?> overview = const Value.absent(),
    Value<String?> releaseDate = const Value.absent(),
    Value<String?> genresJson = const Value.absent(),
    DateTime? cachedAt,
  }) => CachedMoviesData(
    movieId: movieId ?? this.movieId,
    title: title ?? this.title,
    posterPath: posterPath.present ? posterPath.value : this.posterPath,
    overview: overview.present ? overview.value : this.overview,
    releaseDate: releaseDate.present ? releaseDate.value : this.releaseDate,
    genresJson: genresJson.present ? genresJson.value : this.genresJson,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedMoviesData copyWithCompanion(CachedMoviesTableCompanion data) {
    return CachedMoviesData(
      movieId: data.movieId.present ? data.movieId.value : this.movieId,
      title: data.title.present ? data.title.value : this.title,
      posterPath: data.posterPath.present
          ? data.posterPath.value
          : this.posterPath,
      overview: data.overview.present ? data.overview.value : this.overview,
      releaseDate: data.releaseDate.present
          ? data.releaseDate.value
          : this.releaseDate,
      genresJson: data.genresJson.present
          ? data.genresJson.value
          : this.genresJson,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedMoviesData(')
          ..write('movieId: $movieId, ')
          ..write('title: $title, ')
          ..write('posterPath: $posterPath, ')
          ..write('overview: $overview, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('genresJson: $genresJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    movieId,
    title,
    posterPath,
    overview,
    releaseDate,
    genresJson,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedMoviesData &&
          other.movieId == this.movieId &&
          other.title == this.title &&
          other.posterPath == this.posterPath &&
          other.overview == this.overview &&
          other.releaseDate == this.releaseDate &&
          other.genresJson == this.genresJson &&
          other.cachedAt == this.cachedAt);
}

class CachedMoviesTableCompanion extends UpdateCompanion<CachedMoviesData> {
  final Value<int> movieId;
  final Value<String> title;
  final Value<String?> posterPath;
  final Value<String?> overview;
  final Value<String?> releaseDate;
  final Value<String?> genresJson;
  final Value<DateTime> cachedAt;
  const CachedMoviesTableCompanion({
    this.movieId = const Value.absent(),
    this.title = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.overview = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.genresJson = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  CachedMoviesTableCompanion.insert({
    this.movieId = const Value.absent(),
    required String title,
    this.posterPath = const Value.absent(),
    this.overview = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.genresJson = const Value.absent(),
    required DateTime cachedAt,
  }) : title = Value(title),
       cachedAt = Value(cachedAt);
  static Insertable<CachedMoviesData> custom({
    Expression<int>? movieId,
    Expression<String>? title,
    Expression<String>? posterPath,
    Expression<String>? overview,
    Expression<String>? releaseDate,
    Expression<String>? genresJson,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (movieId != null) 'movie_id': movieId,
      if (title != null) 'title': title,
      if (posterPath != null) 'poster_path': posterPath,
      if (overview != null) 'overview': overview,
      if (releaseDate != null) 'release_date': releaseDate,
      if (genresJson != null) 'genres_json': genresJson,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  CachedMoviesTableCompanion copyWith({
    Value<int>? movieId,
    Value<String>? title,
    Value<String?>? posterPath,
    Value<String?>? overview,
    Value<String?>? releaseDate,
    Value<String?>? genresJson,
    Value<DateTime>? cachedAt,
  }) {
    return CachedMoviesTableCompanion(
      movieId: movieId ?? this.movieId,
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
      overview: overview ?? this.overview,
      releaseDate: releaseDate ?? this.releaseDate,
      genresJson: genresJson ?? this.genresJson,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (movieId.present) {
      map['movie_id'] = Variable<int>(movieId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (posterPath.present) {
      map['poster_path'] = Variable<String>(posterPath.value);
    }
    if (overview.present) {
      map['overview'] = Variable<String>(overview.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<String>(releaseDate.value);
    }
    if (genresJson.present) {
      map['genres_json'] = Variable<String>(genresJson.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedMoviesTableCompanion(')
          ..write('movieId: $movieId, ')
          ..write('title: $title, ')
          ..write('posterPath: $posterPath, ')
          ..write('overview: $overview, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('genresJson: $genresJson, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $ListMovieRelationsTableTable extends ListMovieRelationsTable
    with TableInfo<$ListMovieRelationsTableTable, ListMovieRelationData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListMovieRelationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<String> listId = GeneratedColumn<String>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _movieIdMeta = const VerificationMeta(
    'movieId',
  );
  @override
  late final GeneratedColumn<int> movieId = GeneratedColumn<int>(
    'movie_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uid,
    listId,
    movieId,
    addedAt,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'list_movie_relations_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ListMovieRelationData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('movie_id')) {
      context.handle(
        _movieIdMeta,
        movieId.isAcceptableOrUnknown(data['movie_id']!, _movieIdMeta),
      );
    } else if (isInserting) {
      context.missing(_movieIdMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {uid, listId, movieId},
  ];
  @override
  ListMovieRelationData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListMovieRelationData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_id'],
      )!,
      movieId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}movie_id'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      ),
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $ListMovieRelationsTableTable createAlias(String alias) {
    return $ListMovieRelationsTableTable(attachedDatabase, alias);
  }
}

class ListMovieRelationData extends DataClass
    implements Insertable<ListMovieRelationData> {
  final int id;
  final String uid;
  final String listId;
  final int movieId;
  final DateTime? addedAt;
  final DateTime cachedAt;
  const ListMovieRelationData({
    required this.id,
    required this.uid,
    required this.listId,
    required this.movieId,
    this.addedAt,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uid'] = Variable<String>(uid);
    map['list_id'] = Variable<String>(listId);
    map['movie_id'] = Variable<int>(movieId);
    if (!nullToAbsent || addedAt != null) {
      map['added_at'] = Variable<DateTime>(addedAt);
    }
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  ListMovieRelationsTableCompanion toCompanion(bool nullToAbsent) {
    return ListMovieRelationsTableCompanion(
      id: Value(id),
      uid: Value(uid),
      listId: Value(listId),
      movieId: Value(movieId),
      addedAt: addedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(addedAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory ListMovieRelationData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListMovieRelationData(
      id: serializer.fromJson<int>(json['id']),
      uid: serializer.fromJson<String>(json['uid']),
      listId: serializer.fromJson<String>(json['listId']),
      movieId: serializer.fromJson<int>(json['movieId']),
      addedAt: serializer.fromJson<DateTime?>(json['addedAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uid': serializer.toJson<String>(uid),
      'listId': serializer.toJson<String>(listId),
      'movieId': serializer.toJson<int>(movieId),
      'addedAt': serializer.toJson<DateTime?>(addedAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  ListMovieRelationData copyWith({
    int? id,
    String? uid,
    String? listId,
    int? movieId,
    Value<DateTime?> addedAt = const Value.absent(),
    DateTime? cachedAt,
  }) => ListMovieRelationData(
    id: id ?? this.id,
    uid: uid ?? this.uid,
    listId: listId ?? this.listId,
    movieId: movieId ?? this.movieId,
    addedAt: addedAt.present ? addedAt.value : this.addedAt,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  ListMovieRelationData copyWithCompanion(
    ListMovieRelationsTableCompanion data,
  ) {
    return ListMovieRelationData(
      id: data.id.present ? data.id.value : this.id,
      uid: data.uid.present ? data.uid.value : this.uid,
      listId: data.listId.present ? data.listId.value : this.listId,
      movieId: data.movieId.present ? data.movieId.value : this.movieId,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListMovieRelationData(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('listId: $listId, ')
          ..write('movieId: $movieId, ')
          ..write('addedAt: $addedAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uid, listId, movieId, addedAt, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListMovieRelationData &&
          other.id == this.id &&
          other.uid == this.uid &&
          other.listId == this.listId &&
          other.movieId == this.movieId &&
          other.addedAt == this.addedAt &&
          other.cachedAt == this.cachedAt);
}

class ListMovieRelationsTableCompanion
    extends UpdateCompanion<ListMovieRelationData> {
  final Value<int> id;
  final Value<String> uid;
  final Value<String> listId;
  final Value<int> movieId;
  final Value<DateTime?> addedAt;
  final Value<DateTime> cachedAt;
  const ListMovieRelationsTableCompanion({
    this.id = const Value.absent(),
    this.uid = const Value.absent(),
    this.listId = const Value.absent(),
    this.movieId = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  ListMovieRelationsTableCompanion.insert({
    this.id = const Value.absent(),
    required String uid,
    required String listId,
    required int movieId,
    this.addedAt = const Value.absent(),
    required DateTime cachedAt,
  }) : uid = Value(uid),
       listId = Value(listId),
       movieId = Value(movieId),
       cachedAt = Value(cachedAt);
  static Insertable<ListMovieRelationData> custom({
    Expression<int>? id,
    Expression<String>? uid,
    Expression<String>? listId,
    Expression<int>? movieId,
    Expression<DateTime>? addedAt,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uid != null) 'uid': uid,
      if (listId != null) 'list_id': listId,
      if (movieId != null) 'movie_id': movieId,
      if (addedAt != null) 'added_at': addedAt,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  ListMovieRelationsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? uid,
    Value<String>? listId,
    Value<int>? movieId,
    Value<DateTime?>? addedAt,
    Value<DateTime>? cachedAt,
  }) {
    return ListMovieRelationsTableCompanion(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      listId: listId ?? this.listId,
      movieId: movieId ?? this.movieId,
      addedAt: addedAt ?? this.addedAt,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<String>(listId.value);
    }
    if (movieId.present) {
      map['movie_id'] = Variable<int>(movieId.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListMovieRelationsTableCompanion(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('listId: $listId, ')
          ..write('movieId: $movieId, ')
          ..write('addedAt: $addedAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

class $CachedRatingsTableTable extends CachedRatingsTable
    with TableInfo<$CachedRatingsTableTable, CachedRatingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedRatingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _movieIdMeta = const VerificationMeta(
    'movieId',
  );
  @override
  late final GeneratedColumn<int> movieId = GeneratedColumn<int>(
    'movie_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _starsMeta = const VerificationMeta('stars');
  @override
  late final GeneratedColumn<double> stars = GeneratedColumn<double>(
    'stars',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uid,
    movieId,
    stars,
    updatedAt,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_ratings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedRatingData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('movie_id')) {
      context.handle(
        _movieIdMeta,
        movieId.isAcceptableOrUnknown(data['movie_id']!, _movieIdMeta),
      );
    } else if (isInserting) {
      context.missing(_movieIdMeta);
    }
    if (data.containsKey('stars')) {
      context.handle(
        _starsMeta,
        stars.isAcceptableOrUnknown(data['stars']!, _starsMeta),
      );
    } else if (isInserting) {
      context.missing(_starsMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {uid, movieId},
  ];
  @override
  CachedRatingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedRatingData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      movieId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}movie_id'],
      )!,
      stars: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stars'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CachedRatingsTableTable createAlias(String alias) {
    return $CachedRatingsTableTable(attachedDatabase, alias);
  }
}

class CachedRatingData extends DataClass
    implements Insertable<CachedRatingData> {
  final int id;
  final String uid;
  final int movieId;
  final double stars;
  final DateTime updatedAt;
  final DateTime cachedAt;
  const CachedRatingData({
    required this.id,
    required this.uid,
    required this.movieId,
    required this.stars,
    required this.updatedAt,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uid'] = Variable<String>(uid);
    map['movie_id'] = Variable<int>(movieId);
    map['stars'] = Variable<double>(stars);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedRatingsTableCompanion toCompanion(bool nullToAbsent) {
    return CachedRatingsTableCompanion(
      id: Value(id),
      uid: Value(uid),
      movieId: Value(movieId),
      stars: Value(stars),
      updatedAt: Value(updatedAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedRatingData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedRatingData(
      id: serializer.fromJson<int>(json['id']),
      uid: serializer.fromJson<String>(json['uid']),
      movieId: serializer.fromJson<int>(json['movieId']),
      stars: serializer.fromJson<double>(json['stars']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uid': serializer.toJson<String>(uid),
      'movieId': serializer.toJson<int>(movieId),
      'stars': serializer.toJson<double>(stars),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedRatingData copyWith({
    int? id,
    String? uid,
    int? movieId,
    double? stars,
    DateTime? updatedAt,
    DateTime? cachedAt,
  }) => CachedRatingData(
    id: id ?? this.id,
    uid: uid ?? this.uid,
    movieId: movieId ?? this.movieId,
    stars: stars ?? this.stars,
    updatedAt: updatedAt ?? this.updatedAt,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CachedRatingData copyWithCompanion(CachedRatingsTableCompanion data) {
    return CachedRatingData(
      id: data.id.present ? data.id.value : this.id,
      uid: data.uid.present ? data.uid.value : this.uid,
      movieId: data.movieId.present ? data.movieId.value : this.movieId,
      stars: data.stars.present ? data.stars.value : this.stars,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedRatingData(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('movieId: $movieId, ')
          ..write('stars: $stars, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uid, movieId, stars, updatedAt, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedRatingData &&
          other.id == this.id &&
          other.uid == this.uid &&
          other.movieId == this.movieId &&
          other.stars == this.stars &&
          other.updatedAt == this.updatedAt &&
          other.cachedAt == this.cachedAt);
}

class CachedRatingsTableCompanion extends UpdateCompanion<CachedRatingData> {
  final Value<int> id;
  final Value<String> uid;
  final Value<int> movieId;
  final Value<double> stars;
  final Value<DateTime> updatedAt;
  final Value<DateTime> cachedAt;
  const CachedRatingsTableCompanion({
    this.id = const Value.absent(),
    this.uid = const Value.absent(),
    this.movieId = const Value.absent(),
    this.stars = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
  });
  CachedRatingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String uid,
    required int movieId,
    required double stars,
    required DateTime updatedAt,
    required DateTime cachedAt,
  }) : uid = Value(uid),
       movieId = Value(movieId),
       stars = Value(stars),
       updatedAt = Value(updatedAt),
       cachedAt = Value(cachedAt);
  static Insertable<CachedRatingData> custom({
    Expression<int>? id,
    Expression<String>? uid,
    Expression<int>? movieId,
    Expression<double>? stars,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? cachedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uid != null) 'uid': uid,
      if (movieId != null) 'movie_id': movieId,
      if (stars != null) 'stars': stars,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (cachedAt != null) 'cached_at': cachedAt,
    });
  }

  CachedRatingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? uid,
    Value<int>? movieId,
    Value<double>? stars,
    Value<DateTime>? updatedAt,
    Value<DateTime>? cachedAt,
  }) {
    return CachedRatingsTableCompanion(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      movieId: movieId ?? this.movieId,
      stars: stars ?? this.stars,
      updatedAt: updatedAt ?? this.updatedAt,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (movieId.present) {
      map['movie_id'] = Variable<int>(movieId.value);
    }
    if (stars.present) {
      map['stars'] = Variable<double>(stars.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedRatingsTableCompanion(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('movieId: $movieId, ')
          ..write('stars: $stars, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTableTable usersTable = $UsersTableTable(this);
  late final $UserListsTableTable userListsTable = $UserListsTableTable(this);
  late final $CachedMoviesTableTable cachedMoviesTable =
      $CachedMoviesTableTable(this);
  late final $ListMovieRelationsTableTable listMovieRelationsTable =
      $ListMovieRelationsTableTable(this);
  late final $CachedRatingsTableTable cachedRatingsTable =
      $CachedRatingsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    usersTable,
    userListsTable,
    cachedMoviesTable,
    listMovieRelationsTable,
    cachedRatingsTable,
  ];
}

typedef $$UsersTableTableCreateCompanionBuilder =
    UsersTableCompanion Function({
      required String uid,
      required String email,
      required String username,
      Value<String?> avatarUrl,
      required DateTime updatedAt,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$UsersTableTableUpdateCompanionBuilder =
    UsersTableCompanion Function({
      Value<String> uid,
      Value<String> email,
      Value<String> username,
      Value<String?> avatarUrl,
      Value<DateTime> updatedAt,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$UsersTableTableFilterComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$UsersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTableTable,
          UserLocalEntity,
          $$UsersTableTableFilterComposer,
          $$UsersTableTableOrderingComposer,
          $$UsersTableTableAnnotationComposer,
          $$UsersTableTableCreateCompanionBuilder,
          $$UsersTableTableUpdateCompanionBuilder,
          (
            UserLocalEntity,
            BaseReferences<_$AppDatabase, $UsersTableTable, UserLocalEntity>,
          ),
          UserLocalEntity,
          PrefetchHooks Function()
        > {
  $$UsersTableTableTableManager(_$AppDatabase db, $UsersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uid = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersTableCompanion(
                uid: uid,
                email: email,
                username: username,
                avatarUrl: avatarUrl,
                updatedAt: updatedAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uid,
                required String email,
                required String username,
                Value<String?> avatarUrl = const Value.absent(),
                required DateTime updatedAt,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => UsersTableCompanion.insert(
                uid: uid,
                email: email,
                username: username,
                avatarUrl: avatarUrl,
                updatedAt: updatedAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTableTable,
      UserLocalEntity,
      $$UsersTableTableFilterComposer,
      $$UsersTableTableOrderingComposer,
      $$UsersTableTableAnnotationComposer,
      $$UsersTableTableCreateCompanionBuilder,
      $$UsersTableTableUpdateCompanionBuilder,
      (
        UserLocalEntity,
        BaseReferences<_$AppDatabase, $UsersTableTable, UserLocalEntity>,
      ),
      UserLocalEntity,
      PrefetchHooks Function()
    >;
typedef $$UserListsTableTableCreateCompanionBuilder =
    UserListsTableCompanion Function({
      required String listId,
      required String uid,
      required String name,
      required String type,
      Value<String?> iconName,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$UserListsTableTableUpdateCompanionBuilder =
    UserListsTableCompanion Function({
      Value<String> listId,
      Value<String> uid,
      Value<String> name,
      Value<String> type,
      Value<String?> iconName,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$UserListsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserListsTableTable> {
  $$UserListsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserListsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserListsTableTable> {
  $$UserListsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserListsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserListsTableTable> {
  $$UserListsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get listId =>
      $composableBuilder(column: $table.listId, builder: (column) => column);

  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$UserListsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserListsTableTable,
          UserListLocalEntity,
          $$UserListsTableTableFilterComposer,
          $$UserListsTableTableOrderingComposer,
          $$UserListsTableTableAnnotationComposer,
          $$UserListsTableTableCreateCompanionBuilder,
          $$UserListsTableTableUpdateCompanionBuilder,
          (
            UserListLocalEntity,
            BaseReferences<
              _$AppDatabase,
              $UserListsTableTable,
              UserListLocalEntity
            >,
          ),
          UserListLocalEntity,
          PrefetchHooks Function()
        > {
  $$UserListsTableTableTableManager(
    _$AppDatabase db,
    $UserListsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserListsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserListsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserListsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> listId = const Value.absent(),
                Value<String> uid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> iconName = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserListsTableCompanion(
                listId: listId,
                uid: uid,
                name: name,
                type: type,
                iconName: iconName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String listId,
                required String uid,
                required String name,
                required String type,
                Value<String?> iconName = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserListsTableCompanion.insert(
                listId: listId,
                uid: uid,
                name: name,
                type: type,
                iconName: iconName,
                createdAt: createdAt,
                updatedAt: updatedAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserListsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserListsTableTable,
      UserListLocalEntity,
      $$UserListsTableTableFilterComposer,
      $$UserListsTableTableOrderingComposer,
      $$UserListsTableTableAnnotationComposer,
      $$UserListsTableTableCreateCompanionBuilder,
      $$UserListsTableTableUpdateCompanionBuilder,
      (
        UserListLocalEntity,
        BaseReferences<
          _$AppDatabase,
          $UserListsTableTable,
          UserListLocalEntity
        >,
      ),
      UserListLocalEntity,
      PrefetchHooks Function()
    >;
typedef $$CachedMoviesTableTableCreateCompanionBuilder =
    CachedMoviesTableCompanion Function({
      Value<int> movieId,
      required String title,
      Value<String?> posterPath,
      Value<String?> overview,
      Value<String?> releaseDate,
      Value<String?> genresJson,
      required DateTime cachedAt,
    });
typedef $$CachedMoviesTableTableUpdateCompanionBuilder =
    CachedMoviesTableCompanion Function({
      Value<int> movieId,
      Value<String> title,
      Value<String?> posterPath,
      Value<String?> overview,
      Value<String?> releaseDate,
      Value<String?> genresJson,
      Value<DateTime> cachedAt,
    });

class $$CachedMoviesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CachedMoviesTableTable> {
  $$CachedMoviesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get movieId => $composableBuilder(
    column: $table.movieId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genresJson => $composableBuilder(
    column: $table.genresJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedMoviesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedMoviesTableTable> {
  $$CachedMoviesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get movieId => $composableBuilder(
    column: $table.movieId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get overview => $composableBuilder(
    column: $table.overview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genresJson => $composableBuilder(
    column: $table.genresJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedMoviesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedMoviesTableTable> {
  $$CachedMoviesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get movieId =>
      $composableBuilder(column: $table.movieId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get overview =>
      $composableBuilder(column: $table.overview, builder: (column) => column);

  GeneratedColumn<String> get releaseDate => $composableBuilder(
    column: $table.releaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get genresJson => $composableBuilder(
    column: $table.genresJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedMoviesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedMoviesTableTable,
          CachedMoviesData,
          $$CachedMoviesTableTableFilterComposer,
          $$CachedMoviesTableTableOrderingComposer,
          $$CachedMoviesTableTableAnnotationComposer,
          $$CachedMoviesTableTableCreateCompanionBuilder,
          $$CachedMoviesTableTableUpdateCompanionBuilder,
          (
            CachedMoviesData,
            BaseReferences<
              _$AppDatabase,
              $CachedMoviesTableTable,
              CachedMoviesData
            >,
          ),
          CachedMoviesData,
          PrefetchHooks Function()
        > {
  $$CachedMoviesTableTableTableManager(
    _$AppDatabase db,
    $CachedMoviesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedMoviesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedMoviesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedMoviesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> movieId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> posterPath = const Value.absent(),
                Value<String?> overview = const Value.absent(),
                Value<String?> releaseDate = const Value.absent(),
                Value<String?> genresJson = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => CachedMoviesTableCompanion(
                movieId: movieId,
                title: title,
                posterPath: posterPath,
                overview: overview,
                releaseDate: releaseDate,
                genresJson: genresJson,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> movieId = const Value.absent(),
                required String title,
                Value<String?> posterPath = const Value.absent(),
                Value<String?> overview = const Value.absent(),
                Value<String?> releaseDate = const Value.absent(),
                Value<String?> genresJson = const Value.absent(),
                required DateTime cachedAt,
              }) => CachedMoviesTableCompanion.insert(
                movieId: movieId,
                title: title,
                posterPath: posterPath,
                overview: overview,
                releaseDate: releaseDate,
                genresJson: genresJson,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedMoviesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedMoviesTableTable,
      CachedMoviesData,
      $$CachedMoviesTableTableFilterComposer,
      $$CachedMoviesTableTableOrderingComposer,
      $$CachedMoviesTableTableAnnotationComposer,
      $$CachedMoviesTableTableCreateCompanionBuilder,
      $$CachedMoviesTableTableUpdateCompanionBuilder,
      (
        CachedMoviesData,
        BaseReferences<
          _$AppDatabase,
          $CachedMoviesTableTable,
          CachedMoviesData
        >,
      ),
      CachedMoviesData,
      PrefetchHooks Function()
    >;
typedef $$ListMovieRelationsTableTableCreateCompanionBuilder =
    ListMovieRelationsTableCompanion Function({
      Value<int> id,
      required String uid,
      required String listId,
      required int movieId,
      Value<DateTime?> addedAt,
      required DateTime cachedAt,
    });
typedef $$ListMovieRelationsTableTableUpdateCompanionBuilder =
    ListMovieRelationsTableCompanion Function({
      Value<int> id,
      Value<String> uid,
      Value<String> listId,
      Value<int> movieId,
      Value<DateTime?> addedAt,
      Value<DateTime> cachedAt,
    });

class $$ListMovieRelationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ListMovieRelationsTableTable> {
  $$ListMovieRelationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get movieId => $composableBuilder(
    column: $table.movieId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ListMovieRelationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ListMovieRelationsTableTable> {
  $$ListMovieRelationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get movieId => $composableBuilder(
    column: $table.movieId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ListMovieRelationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListMovieRelationsTableTable> {
  $$ListMovieRelationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get listId =>
      $composableBuilder(column: $table.listId, builder: (column) => column);

  GeneratedColumn<int> get movieId =>
      $composableBuilder(column: $table.movieId, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$ListMovieRelationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ListMovieRelationsTableTable,
          ListMovieRelationData,
          $$ListMovieRelationsTableTableFilterComposer,
          $$ListMovieRelationsTableTableOrderingComposer,
          $$ListMovieRelationsTableTableAnnotationComposer,
          $$ListMovieRelationsTableTableCreateCompanionBuilder,
          $$ListMovieRelationsTableTableUpdateCompanionBuilder,
          (
            ListMovieRelationData,
            BaseReferences<
              _$AppDatabase,
              $ListMovieRelationsTableTable,
              ListMovieRelationData
            >,
          ),
          ListMovieRelationData,
          PrefetchHooks Function()
        > {
  $$ListMovieRelationsTableTableTableManager(
    _$AppDatabase db,
    $ListMovieRelationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListMovieRelationsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ListMovieRelationsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ListMovieRelationsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uid = const Value.absent(),
                Value<String> listId = const Value.absent(),
                Value<int> movieId = const Value.absent(),
                Value<DateTime?> addedAt = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => ListMovieRelationsTableCompanion(
                id: id,
                uid: uid,
                listId: listId,
                movieId: movieId,
                addedAt: addedAt,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uid,
                required String listId,
                required int movieId,
                Value<DateTime?> addedAt = const Value.absent(),
                required DateTime cachedAt,
              }) => ListMovieRelationsTableCompanion.insert(
                id: id,
                uid: uid,
                listId: listId,
                movieId: movieId,
                addedAt: addedAt,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ListMovieRelationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ListMovieRelationsTableTable,
      ListMovieRelationData,
      $$ListMovieRelationsTableTableFilterComposer,
      $$ListMovieRelationsTableTableOrderingComposer,
      $$ListMovieRelationsTableTableAnnotationComposer,
      $$ListMovieRelationsTableTableCreateCompanionBuilder,
      $$ListMovieRelationsTableTableUpdateCompanionBuilder,
      (
        ListMovieRelationData,
        BaseReferences<
          _$AppDatabase,
          $ListMovieRelationsTableTable,
          ListMovieRelationData
        >,
      ),
      ListMovieRelationData,
      PrefetchHooks Function()
    >;
typedef $$CachedRatingsTableTableCreateCompanionBuilder =
    CachedRatingsTableCompanion Function({
      Value<int> id,
      required String uid,
      required int movieId,
      required double stars,
      required DateTime updatedAt,
      required DateTime cachedAt,
    });
typedef $$CachedRatingsTableTableUpdateCompanionBuilder =
    CachedRatingsTableCompanion Function({
      Value<int> id,
      Value<String> uid,
      Value<int> movieId,
      Value<double> stars,
      Value<DateTime> updatedAt,
      Value<DateTime> cachedAt,
    });

class $$CachedRatingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CachedRatingsTableTable> {
  $$CachedRatingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get movieId => $composableBuilder(
    column: $table.movieId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedRatingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedRatingsTableTable> {
  $$CachedRatingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get movieId => $composableBuilder(
    column: $table.movieId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stars => $composableBuilder(
    column: $table.stars,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedRatingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedRatingsTableTable> {
  $$CachedRatingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<int> get movieId =>
      $composableBuilder(column: $table.movieId, builder: (column) => column);

  GeneratedColumn<double> get stars =>
      $composableBuilder(column: $table.stars, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedRatingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedRatingsTableTable,
          CachedRatingData,
          $$CachedRatingsTableTableFilterComposer,
          $$CachedRatingsTableTableOrderingComposer,
          $$CachedRatingsTableTableAnnotationComposer,
          $$CachedRatingsTableTableCreateCompanionBuilder,
          $$CachedRatingsTableTableUpdateCompanionBuilder,
          (
            CachedRatingData,
            BaseReferences<
              _$AppDatabase,
              $CachedRatingsTableTable,
              CachedRatingData
            >,
          ),
          CachedRatingData,
          PrefetchHooks Function()
        > {
  $$CachedRatingsTableTableTableManager(
    _$AppDatabase db,
    $CachedRatingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedRatingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedRatingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedRatingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uid = const Value.absent(),
                Value<int> movieId = const Value.absent(),
                Value<double> stars = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
              }) => CachedRatingsTableCompanion(
                id: id,
                uid: uid,
                movieId: movieId,
                stars: stars,
                updatedAt: updatedAt,
                cachedAt: cachedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uid,
                required int movieId,
                required double stars,
                required DateTime updatedAt,
                required DateTime cachedAt,
              }) => CachedRatingsTableCompanion.insert(
                id: id,
                uid: uid,
                movieId: movieId,
                stars: stars,
                updatedAt: updatedAt,
                cachedAt: cachedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedRatingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedRatingsTableTable,
      CachedRatingData,
      $$CachedRatingsTableTableFilterComposer,
      $$CachedRatingsTableTableOrderingComposer,
      $$CachedRatingsTableTableAnnotationComposer,
      $$CachedRatingsTableTableCreateCompanionBuilder,
      $$CachedRatingsTableTableUpdateCompanionBuilder,
      (
        CachedRatingData,
        BaseReferences<
          _$AppDatabase,
          $CachedRatingsTableTable,
          CachedRatingData
        >,
      ),
      CachedRatingData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db, _db.usersTable);
  $$UserListsTableTableTableManager get userListsTable =>
      $$UserListsTableTableTableManager(_db, _db.userListsTable);
  $$CachedMoviesTableTableTableManager get cachedMoviesTable =>
      $$CachedMoviesTableTableTableManager(_db, _db.cachedMoviesTable);
  $$ListMovieRelationsTableTableTableManager get listMovieRelationsTable =>
      $$ListMovieRelationsTableTableTableManager(
        _db,
        _db.listMovieRelationsTable,
      );
  $$CachedRatingsTableTableTableManager get cachedRatingsTable =>
      $$CachedRatingsTableTableTableManager(_db, _db.cachedRatingsTable);
}
