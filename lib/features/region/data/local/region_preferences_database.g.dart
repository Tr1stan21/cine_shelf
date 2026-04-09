// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_preferences_database.dart';

// ignore_for_file: type=lint
class $RegionPreferencesTable extends RegionPreferences
    with TableInfo<$RegionPreferencesTable, RegionPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RegionPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionCodeMeta = const VerificationMeta(
    'regionCode',
  );
  @override
  late final GeneratedColumn<String> regionCode = GeneratedColumn<String>(
    'region_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 2,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, regionCode];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'region_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<RegionPreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('region_code')) {
      context.handle(
        _regionCodeMeta,
        regionCode.isAcceptableOrUnknown(data['region_code']!, _regionCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_regionCodeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RegionPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RegionPreference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      regionCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_code'],
      )!,
    );
  }

  @override
  $RegionPreferencesTable createAlias(String alias) {
    return $RegionPreferencesTable(attachedDatabase, alias);
  }
}

class RegionPreference extends DataClass
    implements Insertable<RegionPreference> {
  final int id;
  final String regionCode;
  const RegionPreference({required this.id, required this.regionCode});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['region_code'] = Variable<String>(regionCode);
    return map;
  }

  RegionPreferencesCompanion toCompanion(bool nullToAbsent) {
    return RegionPreferencesCompanion(
      id: Value(id),
      regionCode: Value(regionCode),
    );
  }

  factory RegionPreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RegionPreference(
      id: serializer.fromJson<int>(json['id']),
      regionCode: serializer.fromJson<String>(json['regionCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'regionCode': serializer.toJson<String>(regionCode),
    };
  }

  RegionPreference copyWith({int? id, String? regionCode}) => RegionPreference(
    id: id ?? this.id,
    regionCode: regionCode ?? this.regionCode,
  );
  RegionPreference copyWithCompanion(RegionPreferencesCompanion data) {
    return RegionPreference(
      id: data.id.present ? data.id.value : this.id,
      regionCode: data.regionCode.present
          ? data.regionCode.value
          : this.regionCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RegionPreference(')
          ..write('id: $id, ')
          ..write('regionCode: $regionCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, regionCode);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RegionPreference &&
          other.id == this.id &&
          other.regionCode == this.regionCode);
}

class RegionPreferencesCompanion extends UpdateCompanion<RegionPreference> {
  final Value<int> id;
  final Value<String> regionCode;
  const RegionPreferencesCompanion({
    this.id = const Value.absent(),
    this.regionCode = const Value.absent(),
  });
  RegionPreferencesCompanion.insert({
    this.id = const Value.absent(),
    required String regionCode,
  }) : regionCode = Value(regionCode);
  static Insertable<RegionPreference> custom({
    Expression<int>? id,
    Expression<String>? regionCode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (regionCode != null) 'region_code': regionCode,
    });
  }

  RegionPreferencesCompanion copyWith({
    Value<int>? id,
    Value<String>? regionCode,
  }) {
    return RegionPreferencesCompanion(
      id: id ?? this.id,
      regionCode: regionCode ?? this.regionCode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (regionCode.present) {
      map['region_code'] = Variable<String>(regionCode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RegionPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('regionCode: $regionCode')
          ..write(')'))
        .toString();
  }
}

abstract class _$RegionPreferencesDatabase extends GeneratedDatabase {
  _$RegionPreferencesDatabase(QueryExecutor e) : super(e);
  $RegionPreferencesDatabaseManager get managers =>
      $RegionPreferencesDatabaseManager(this);
  late final $RegionPreferencesTable regionPreferences =
      $RegionPreferencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [regionPreferences];
}

typedef $$RegionPreferencesTableCreateCompanionBuilder =
    RegionPreferencesCompanion Function({
      Value<int> id,
      required String regionCode,
    });
typedef $$RegionPreferencesTableUpdateCompanionBuilder =
    RegionPreferencesCompanion Function({
      Value<int> id,
      Value<String> regionCode,
    });

class $$RegionPreferencesTableFilterComposer
    extends Composer<_$RegionPreferencesDatabase, $RegionPreferencesTable> {
  $$RegionPreferencesTableFilterComposer({
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

  ColumnFilters<String> get regionCode => $composableBuilder(
    column: $table.regionCode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RegionPreferencesTableOrderingComposer
    extends Composer<_$RegionPreferencesDatabase, $RegionPreferencesTable> {
  $$RegionPreferencesTableOrderingComposer({
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

  ColumnOrderings<String> get regionCode => $composableBuilder(
    column: $table.regionCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RegionPreferencesTableAnnotationComposer
    extends Composer<_$RegionPreferencesDatabase, $RegionPreferencesTable> {
  $$RegionPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get regionCode => $composableBuilder(
    column: $table.regionCode,
    builder: (column) => column,
  );
}

class $$RegionPreferencesTableTableManager
    extends
        RootTableManager<
          _$RegionPreferencesDatabase,
          $RegionPreferencesTable,
          RegionPreference,
          $$RegionPreferencesTableFilterComposer,
          $$RegionPreferencesTableOrderingComposer,
          $$RegionPreferencesTableAnnotationComposer,
          $$RegionPreferencesTableCreateCompanionBuilder,
          $$RegionPreferencesTableUpdateCompanionBuilder,
          (
            RegionPreference,
            BaseReferences<
              _$RegionPreferencesDatabase,
              $RegionPreferencesTable,
              RegionPreference
            >,
          ),
          RegionPreference,
          PrefetchHooks Function()
        > {
  $$RegionPreferencesTableTableManager(
    _$RegionPreferencesDatabase db,
    $RegionPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RegionPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RegionPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RegionPreferencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> regionCode = const Value.absent(),
              }) => RegionPreferencesCompanion(id: id, regionCode: regionCode),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String regionCode,
              }) => RegionPreferencesCompanion.insert(
                id: id,
                regionCode: regionCode,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RegionPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$RegionPreferencesDatabase,
      $RegionPreferencesTable,
      RegionPreference,
      $$RegionPreferencesTableFilterComposer,
      $$RegionPreferencesTableOrderingComposer,
      $$RegionPreferencesTableAnnotationComposer,
      $$RegionPreferencesTableCreateCompanionBuilder,
      $$RegionPreferencesTableUpdateCompanionBuilder,
      (
        RegionPreference,
        BaseReferences<
          _$RegionPreferencesDatabase,
          $RegionPreferencesTable,
          RegionPreference
        >,
      ),
      RegionPreference,
      PrefetchHooks Function()
    >;

class $RegionPreferencesDatabaseManager {
  final _$RegionPreferencesDatabase _db;
  $RegionPreferencesDatabaseManager(this._db);
  $$RegionPreferencesTableTableManager get regionPreferences =>
      $$RegionPreferencesTableTableManager(_db, _db.regionPreferences);
}
