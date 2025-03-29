import 'package:flutter/material.dart';
import 'package:pokedex_app/page/pokemon_detail_screen.dart';
import 'package:pokedex_app/repository/pokedex_repository.dart';
import 'package:pokedex_app/widgets/pokemon_screen_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pokemonRepository = PokedexRepository();
  String searchQuery = "";
  List<String> allPokemonNames = [];
  List<String> filteredNames = [];
  @override
  void initState() {
    super.initState();
    _loadPokemonNames();
  }

  void _filterPokemonNames(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredNames = allPokemonNames
          .where((name) => name.toLowerCase().contains(searchQuery))
          .toList();
    });
  }

  Future<void> _loadPokemonNames() async {
    final List<String> names = await pokemonRepository.getAllPokemonNames();
    try {
      setState(() {
        allPokemonNames = names;
        filteredNames = names;
      });
    } catch (e) {
      print("Erro ao carregar nomes dos Pokémon: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.search,
          color: Colors.white,
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: "Pesquisar Pokémon...",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (query) {
            setState(() {
              _filterPokemonNames(query);
            });
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            height: 1000,
            width: 1000,
            child: Image.asset(
              'assets/images/pokebal.png',
              fit: BoxFit.cover,
            ),
          ),
          searchQuery.isEmpty ? _buildPokemonGrid() : _buildSearchResults(),
        ],
      ),
    );
  }

  Widget _buildPokemonGrid() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 1025,
        itemBuilder: (context, index) {
          return FutureBuilder(
            future: pokemonRepository.getPokemonsWithId(index + 1),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return ListTile(
                  title: Text("Erro ao carregar Pokémon"),
                  subtitle: Text(snapshot.error.toString()),
                );
              } else {
                var pokemon = snapshot.data as Map<String, dynamic>;
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PokemonDetailScreen(
                            pokemon: pokemon,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: PokemonScreenVeiw(pokemon: pokemon));
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: filteredNames.length,
        itemBuilder: (context, index) {
          return FutureBuilder(
            future: pokemonRepository.getPokemonWithName(filteredNames[index]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return ListTile(
                  title: Text("Erro ao carregar Pokémon"),
                  subtitle: Text(snapshot.error.toString()),
                );
              } else {
                var pokemon = snapshot.data as Map<String, dynamic>;
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PokemonDetailScreen(
                            pokemon: pokemon,
                            initialIndex: index,
                          ),
                        ),
                      );
                    },
                    child: PokemonScreenVeiw(pokemon: pokemon));
              }
            },
          );
        },
      ),
    );
  }
}
