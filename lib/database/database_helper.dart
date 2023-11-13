import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/manage_customers_model.dart';

class DatabaseHelper {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), 'customers.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
            '''
          CREATE TABLE customers(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            vehicleName TEXT,
            regNo TEXT,
            dueAmount REAL,
            paidAmount REAL
          )
          '''
        );
      },
    );
  }

  Future<void> insertCustomer(CustomerCard customer) async {
    final db = await database;
    await db.insert('customers', customer.toMap());
  }

  Future<void> updateCustomer(CustomerCard customer) async {
    final db = await database;
    await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<List<CustomerCard>> getCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('customers');
    return List.generate(maps.length, (index) {
      return CustomerCard.fromMap(maps[index]);
    });
  }
}
