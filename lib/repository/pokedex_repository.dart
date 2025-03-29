import 'dart:convert';

import 'package:http/http.dart';

class PokedexRepository {
  final client = Client();

  Future<Map<String, dynamic>> getPokemonsWithId(int id) async {
    final String dataBase = 'https://pokeapi.co/api/v2/pokemon/$id/';
    final response = await client.get(Uri.parse(dataBase));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data; // Retorna a lista de Pokémon
    } else {
      throw Exception('Erro ao carregar Pokémon');
    }
  }

  Future<Map<String, dynamic>> getPokemonWithName(String name) async {
    final String dataBase = 'https://pokeapi.co/api/v2/pokemon/$name';
    final response = await client.get(Uri.parse(dataBase));

    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data; // Retorna a lista de Pokémon
      } else {
        throw Exception('Erro ao carregar Pokémon');
      }
    } catch (e) {
      throw Exception('Erro ao carregar Pokémon');
    }
  }

  Future<Map<String, dynamic>> getPokemonEvolutions(int id) async {
    final String dataBase = 'https://pokeapi.co/api/v2/evolution-chain/$id/';
    final response = await client.get(Uri.parse(dataBase));

    try {
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data; // Retorna a lista de Pokémon
      } else {
        throw Exception('Erro ao carregar Pokémon');
      }
    } catch (e) {
      throw Exception('Erro ao carregar Pokémon');
    }
  }

  Future<List<String>> getAllPokemonNames() async {
    final response = await client
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1000'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((pokemon) => pokemon['name'] as String)
          .toList();
    } else {
      throw Exception('Erro ao carregar lista de Pokémon');
    }
  }
}
