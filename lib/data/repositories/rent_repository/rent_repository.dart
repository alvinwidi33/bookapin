import 'package:bookapin/data/models/rents.dart';

abstract class RentRepository {
  Future<void> createRent({
    required String bookId,
    required String userId,
    required int duration,
    required int price,
  });

  Future<List<Rents>> getUserRents(String userId);

  Future<Rents> getRentById(String rentId);

  Future<void> returnBook(String rentId, int fine);
}
