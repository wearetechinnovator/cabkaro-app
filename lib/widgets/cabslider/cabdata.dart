class CabData {
  final String driverName;
  final String carModel;
  final String fare;
  final String eta;
  final String avatarImage;
  final String carImage;
  final List<String> benefits;

  const CabData({
    required this.driverName,
    required this.carModel,
    required this.fare,
    required this.eta,
    this.avatarImage = 'assets/images/avatarimg.png',
    this.carImage = 'assets/images/carimg.png',
    this.benefits = const ['4 Seat Available', 'Air Conditioner', 'Wifi'],
  });
}