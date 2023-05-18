// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorPlayerDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$PlayerDatabaseBuilder databaseBuilder(String name) =>
      _$PlayerDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$PlayerDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$PlayerDatabaseBuilder(null);
}

class _$PlayerDatabaseBuilder {
  _$PlayerDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$PlayerDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$PlayerDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<PlayerDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$PlayerDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$PlayerDatabase extends PlayerDatabase {
  _$PlayerDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PlayerDao? _playerDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Player` (`playerId` TEXT NOT NULL, `highScore` INTEGER NOT NULL, `nickname` TEXT NOT NULL, PRIMARY KEY (`playerId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PlayerDao get playerDao {
    return _playerDaoInstance ??= _$PlayerDao(database, changeListener);
  }
}

class _$PlayerDao extends PlayerDao {
  _$PlayerDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _playerInsertionAdapter = InsertionAdapter(
            database,
            'Player',
            (Player item) => <String, Object?>{
                  'playerId': item.playerId,
                  'highScore': item.highScore,
                  'nickname': item.nickname
                },
            changeListener),
        _playerDeletionAdapter = DeletionAdapter(
            database,
            'Player',
            ['playerId'],
            (Player item) => <String, Object?>{
                  'playerId': item.playerId,
                  'highScore': item.highScore,
                  'nickname': item.nickname
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Player> _playerInsertionAdapter;

  final DeletionAdapter<Player> _playerDeletionAdapter;

  @override
  Future<List<Player>> getAllPlayers() async {
    return _queryAdapter.queryList('SELECT * FROM Player',
        mapper: (Map<String, Object?> row) => Player(row['playerId'] as String,
            row['highScore'] as int, row['nickname'] as String));
  }

  @override
  Stream<List<String>> getAllNickname() {
    return _queryAdapter.queryListStream('SELECT nickname FROM Player',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'Player',
        isView: false);
  }

  @override
  Stream<Player?> findPlayerByNickname(String nickname) {
    return _queryAdapter.queryStream('SELECT * FROM Player WHERE nickname = ?1',
        mapper: (Map<String, Object?> row) => Player(row['playerId'] as String,
            row['highScore'] as int, row['nickname'] as String),
        arguments: [nickname],
        queryableName: 'Player',
        isView: false);
  }

  @override
  Future<void> deletePlayerById(String playerId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM Player WHERE playerId = ?1',
        arguments: [playerId]);
  }

  @override
  Future<void> insertPlayer(Player player) async {
    await _playerInsertionAdapter.insert(player, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePlayer(Player player) async {
    await _playerDeletionAdapter.delete(player);
  }
}
