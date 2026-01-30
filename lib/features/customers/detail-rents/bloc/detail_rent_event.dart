abstract class DetailRentEvent {}

class FetchRentDetail extends DetailRentEvent {
  final String rentId;
  FetchRentDetail({required this.rentId});
}