class PokemonModel {
  final String name;
  final String sprites;
  final String type;

  PokemonModel({
    required this.type,
    required this.name,
    required this.sprites,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      name: json['name'],
      sprites: json['sprites']['front_default'],
      type: json['types'].map((type) => type['type']['name']).join(', '),
    );
  }
}
