import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:jogo_da_memoria/models/carta.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Carta> cartas = [
    Carta(
      id: 1,
      group: 1,
      color: Colors.grey[800],
      image: 'assets/Geralt.png',
    ),
    Carta(
      id: 2,
      group: 1,
      color: Colors.grey[800],
      image: 'assets/Geralt.png',
    ),
    Carta(
      id: 3,
      group: 2,
      color: Colors.purple[900],
      image: 'assets/Yenn.png',
    ),
    Carta(
      id: 4,
      group: 2,
      color: Colors.purple[900],
      image: 'assets/Yenn.png',
    ),
    Carta(
      id: 5,
      group: 3,
      color: Colors.orange[900],
      image: 'assets/Triss.png',
    ),
    Carta(
      id: 6,
      group: 3,
      color: Colors.orange[900],
      image: 'assets/Triss.png',
    ),
    Carta(
      id: 7,
      group: 4,
      color: Colors.green[900],
      image: 'assets/Ciri.png',
    ),
    Carta(
      id: 8,
      group: 4,
      color: Colors.green[900],
      image: 'assets/Ciri.png',
    ),
    Carta(
      id: 9,
      group: 5,
      color: Colors.pink[900],
      image: 'assets/Dandelion.png',
    ),
    Carta(
      id: 10,
      group: 5,
      color: Colors.pink[900],
      image: 'assets/Dandelion.png',
    ),
    Carta(
      id: 11,
      group: 6,
      color: Colors.brown[800],
      image: 'assets/Zoltan.png',
    ),
    Carta(
      id: 12,
      group: 6,
      color: Colors.brown[800],
      image: 'assets/Zoltan.png',
    ),
    Carta(
      id: 13,
      group: 7,
      color: Colors.yellow[900],
      image: 'assets/Shani.png',
    ),
    Carta(
      id: 14,
      group: 7,
      color: Colors.yellow[900],
      image: 'assets/Shani.png',
    ),
    Carta(
      id: 15,
      group: 8,
      color: Colors.red[900],
      image: 'assets/Regis.png',
    ),
    Carta(
      id: 16,
      group: 8,
      color: Colors.red[900],
      image: 'assets/Regis.png',
    )
  ];

  Map<int, List<Carta>> cartasAgrupadas = Map<int, List<Carta>>();
  bool aguardandoCartasErradas = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da Memória'),
      ),
      backgroundColor: Colors.grey[900],
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            child: Image.asset(
              'assets/Logo.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _criaTabuleiroCartas(),
        ],
      ),
    );
  }

  @override
  void initState() {
    cartas.shuffle();
    super.initState();
  }

  Widget _criaTabuleiroCartas() {
    return GridView.count(
      padding: EdgeInsets.all(5.0),
      crossAxisCount: 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: _criaListaCartas(),
      shrinkWrap: true,
    );
  }

  List<Widget> _criaListaCartas() {
    return cartas.map((Carta carta) => _criaCarta(carta)).toList();
  }

  Widget _criaCarta(Carta carta) {
    return GestureDetector(
      onTap: !aguardandoCartasErradas && !carta.visible
          ? () => _mostraCarta(carta)
          : null,
      child: Card(
        child: AnimatedContainer(
          color: carta.visible ? carta.color : Colors.grey,
          duration: Duration(milliseconds: 400),
          child: Image.asset(
            carta.visible ? carta.image : 'assets/Placeholder.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  _mostraCarta(Carta carta) {
    setState(() {
      carta.visible = !carta.visible;
    });
    _verificaAcerto();
  }

  void _verificaAcerto() {
    List<Carta> cartasVisiveis = _getCartasVisiveis();
    if (cartasVisiveis.length >= 2) {
      cartasAgrupadas = _getCartasAgrupadas(cartasVisiveis);
      List<Carta> cartasIncorretas = _getCartasIcorretas(cartasAgrupadas);
      if (cartasIncorretas.length >= 2) {
        _escondeCartas(cartasIncorretas);
      } else {
        _verificaVitoria();
      }
    }
  }

  void _escondeCartas(List<Carta> value) {
    setState(() {
      aguardandoCartasErradas = true;
    });
    Timer(Duration(seconds: 1), () {
      for (var i = 0; i < value.length; i++) {
        setState(() {
          value[i].visible = false;
        });
      }

      setState(() {
        aguardandoCartasErradas = false;
      });
    });
  }

  List<Carta> _getCartasVisiveis() {
    return cartas.where((carta) => carta.visible).toList();
  }

  Map<int, List<Carta>> _getCartasAgrupadas(List<Carta> cartas) {
    return groupBy(cartas, (Carta carta) => carta.group);
  }

  List<Carta> _getCartasIcorretas(
      Map<int, List<Carta>> cartasAgrupadasPorGrupo) {
    List<Carta> cartasIncorretas = [];
    cartasAgrupadasPorGrupo.forEach((key, value) {
      if (value.length < 2) {
        cartasIncorretas.add(value[0]);
      }
    });
    return cartasIncorretas;
  }

  void _verificaVitoria() {
    if (_getCartasVisiveis().length == 16) {
      print('Você venceu!');
    }
  }
}
