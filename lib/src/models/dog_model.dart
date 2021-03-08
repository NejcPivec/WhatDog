class DogModel {
  final int id;
  final String name;
  final String image;

  DogModel({this.id, this.name, this.image});

  factory DogModel.fromMap(Map<String, dynamic> json) => new DogModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
