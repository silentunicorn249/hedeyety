class Gift {
  final String name;
  String description;
  String category;
  double price;
  late bool isPledged;

  Gift({
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.isPledged = false,
  });
}
