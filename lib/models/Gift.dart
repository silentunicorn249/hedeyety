class Gift {
  final String name;
  final String description;
  final String category;
  late final bool isPledged;

  Gift({
    required this.name,
    required this.description,
    required this.category,
    this.isPledged = false,
  });
}
