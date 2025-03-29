import 'package:flutter/material.dart';

class PokemonScreenVeiw extends StatefulWidget {
  const PokemonScreenVeiw({
    super.key,
    required this.pokemon,
  });

  final Map<String, dynamic> pokemon;

  @override
  State<PokemonScreenVeiw> createState() => _PokemonScreenVeiwState();
}

class _PokemonScreenVeiwState extends State<PokemonScreenVeiw> {
  // defini a cor do texto
  Color textColor = Colors.white;
  // set a cor do fundo e do texto baseado no tipo do pokemon
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: setColor(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              widget.pokemon['sprites']['front_default'] ??
                  'https://via.placeholder.com/100',
            ),
            pokemonsTextes(),
          ],
        ),
      ),
    );
  }

  //funcao que gera os texto para melhor organizacao
  Column pokemonsTextes() {
    return Column(
      children: [
        Text(
          widget.pokemon['name'],
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        Text(
          "Tipos: ${widget.pokemon['types'].map((t) => t['type']['name']).join(', ')}",
          style: TextStyle(color: textColor, fontSize: 14),
        ),
        Text(
          'id : ${widget.pokemon['id'].toString()}',
          style: TextStyle(color: textColor, fontSize: 14),
        ),
      ],
    );
  }
}
