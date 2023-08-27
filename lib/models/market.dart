class Market {
   int? id;
   String name;
   String description;
   String image;
   int cityId;
   

   Market({this.id,required this.description,required this.name,
    required this.image,required this.cityId});

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      cityId: json['cityId'],
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'cityId': cityId,
    };
  }

    

}