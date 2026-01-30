import 'package:equatable/equatable.dart';

abstract class RentHistoryEvent extends Equatable {
  const RentHistoryEvent();

  @override
  List<Object?> get props => [];
}

class FetchRentHistory extends RentHistoryEvent {
  final String userId;

  const FetchRentHistory({required this.userId});

  @override
  List<Object?> get props => [userId];
}
