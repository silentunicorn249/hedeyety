class Person {
  String name;
  int events;
  int age;
  String biography;

  // Constructor with default values for age and biography
  Person(this.name, this.events,
      {this.age = 3, this.biography = "No biography available."});

  // Method
  void introduce() {
    print(
        'Hello, my name is $name, I am $age years old, and here is my bio: $biography');
  }
}
