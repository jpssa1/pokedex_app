import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PokemonDetailScreen extends StatefulWidget {
  const PokemonDetailScreen({
    super.key,
    required this.pokemon,
    required this.initialIndex,
  });
  final Map<String, dynamic> pokemon;
  final int initialIndex;

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen>
    with SingleTickerProviderStateMixin {
  Color textColor = Colors.white;
  late TabController _tabController;
  List<Map<String, dynamic>> evolutions = [];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    fetchEvolutionChain();
  }

  Future<void> fetchEvolutionChain() async {
    // Obtém a URL da espécie do Pokémon
    final speciesUrl = widget.pokemon['species']['url'];
    final speciesResponse = await http.get(Uri.parse(speciesUrl));
    final speciesData = json.decode(speciesResponse.body);

    // Obtém a URL da cadeia de evolução
    final evolutionUrl = speciesData['evolution_chain']['url'];
    final evolutionResponse = await http.get(Uri.parse(evolutionUrl));
    final evolutionData = json.decode(evolutionResponse.body);

    List<Map<String, dynamic>> evolutionList = [];
    var current = evolutionData['chain'];

    // Percorre a cadeia de evolução e adiciona os Pokémon à lista
    while (current != null) {
      String name = current['species']['name'];
      int id = int.parse(current['species']['url'].split('/')[6]);

      evolutionList.add({
        'name': name,
        'image':
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
      });

      // Verifica se há evolução para o próximo estágio
      current =
          current['evolves_to'].isNotEmpty ? current['evolves_to'][0] : null;
    }

    // Atualiza o estado para renderizar a evolução na tela
    setState(() {
      evolutions = evolutionList;
    });
  }

  Color setColor() {
    //tipo do pokemon
    String type = widget.pokemon['types'][0]['type']['name'];

    switch (type) {
      //pokemons de grama e inseto fundo verde
      case 'grass':
      case 'bug':
        return Colors.green;
      //pokemons do tipo fogo fundo vermelho
      case 'fire':
        return Colors.red;
      //pokemons do tipo agua fundo azul
      case 'water':
        return Colors.lightBlue;
      // pokemons tipo normal e metal fundo cinza
      case 'normal':
      case 'steel':
        return Colors.grey;
      //pokemons tipo venenoso e fantasma fundo roxo
      case 'poison':
      case 'ghost':
        return Colors.purple;
      //pokemons tipo eletrico fundo amarelo
      case 'electric':
        textColor = Colors.black;
        return Colors.yellow;
      //pokemon tipo terra e pedra fundo marron
      case 'ground':
      case 'rock':
        return Colors.brown;
      //pokemon tipo fada
      case 'fairy':
        return Colors.pinkAccent;
      //pokemon tipo lutador
      case 'fighting':
        return Colors.deepOrange;
      //pokemon tipo psiquico
      case 'psychic':
        return Colors.purpleAccent;
      //pokemon tipo gelo
      case 'ice':
        return Colors.lightBlue;
      //pokemon tipo dragao , dark e  voador
      case 'dragon':
      case 'dark':
      case 'flying':
        return Colors.deepPurple;
      default:
        return Colors.transparent;
    }
  }

  double setPorcent(String status, int statusBase) {
    double maxStatusHp = 255;
    double maxStatusAttack = 181;
    double maxStatusDefense = 230;
    double maxStatusSpecialAttack = 180;
    double maxStatusSpecialDefense = 230;
    double speed = 180;
    switch (status) {
      case 'hp':
        return statusBase / maxStatusHp;
      case 'attack':
        return statusBase / maxStatusAttack;
      case 'defense':
        return statusBase / maxStatusDefense;
      case 'special-attack':
        return statusBase / maxStatusSpecialAttack;
      case 'special-defense':
        return statusBase / maxStatusSpecialDefense;
      case 'speed':
        return statusBase / speed;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: textColor,
            )),
        backgroundColor: setColor(),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            color: setColor(),
            child: Image.asset(
              'assets/images/pokebal.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 450,
              decoration: BoxDecoration(
                color: Color.fromARGB(150, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(13),
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.black45,
                      indicatorColor: setColor(),
                      tabs: [
                        Tab(text: "About"),
                        Tab(text: "Base Stats"),
                        Tab(text: "Evolution"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // About Tab
                          aboutTap(),
                          // Base Stats Tab
                          baseStatusTap(),
                          // Evolution Tab
                          evolutionTap(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          widget.pokemon['name'],
                          style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: textColor),
                        ),
                        Wrap(
                          spacing: 6,
                          children: widget.pokemon["types"]
                              .map<Widget>(
                                (type) => Container(
                                  height: 25,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(60, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                    child: Text(
                                      type['type']['name'],
                                      style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                    Text(
                      '# ${widget.pokemon['id']}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 28,
                      ),
                    )
                  ],
                ),
                IgnorePointer(
                  ignoring: true,
                  child: SizedBox(
                    height: 270,
                    width: 270,
                    child: Image.network(
                      widget.pokemon['sprites']['front_default'] ??
                          'https://via.placeholder.com/100',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding evolutionTap() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: evolutions.isEmpty
          ? Center(
              child:
                  CircularProgressIndicator()) // Exibe um carregamento enquanto os dados chegam
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Define duas colunas
                crossAxisSpacing: 10, // Espaçamento horizontal
                mainAxisSpacing: 10, // Espaçamento vertical
              ),
              itemCount: evolutions.length, // Número de Pokémon na evolução
              itemBuilder: (context, index) {
                final evolution = evolutions[index];
                return Column(
                  children: [
                    Image.network(evolution['image'],
                        width: 100, height: 100), // Exibe a imagem do Pokémon
                    Text(evolution['name']), // Nome do Pokémon abaixo da imagem
                  ],
                );
              },
            ),
    );
  }

  Padding baseStatusTap() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: widget.pokemon['stats'].length,
        itemBuilder: (context, index) {
          var stat = widget.pokemon['stats'][index];
          return Padding(
            padding: EdgeInsets.all(15.0),
            child: LinearPercentIndicator(
              alignment: MainAxisAlignment.spaceBetween,
              barRadius: Radius.circular(20),
              width: 170.0,
              animation: true,
              animationDuration: 1500,
              lineHeight: 22.0,
              leading: Text(
                stat['stat']['name'],
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              percent: setPorcent(stat['stat']['name'], stat['base_stat']),
              center: Text(
                stat['base_stat'].toString(),
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              progressColor: setColor(),
            ),
          );
        },
      ),
    );
  }

  Padding aboutTap() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Especies  ",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " ${widget.pokemon['name']}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Height  ",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " ${widget.pokemon['height']}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Weight   ",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " ${widget.pokemon['weight']}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Abilities  ",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    " ${widget.pokemon['abilities'].map((t) => t['ability']['name']).join(', ')}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
