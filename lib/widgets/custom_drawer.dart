import 'package:applojavirtual/models/user_model.dart';
import 'package:applojavirtual/screens/login_screen.dart';
import 'package:applojavirtual/tiles/drawer_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

final int pageHome = 0;
final int pageProducts = 1;
final int pageStores = 2;
final int pageOrders = 3;

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 203, 236, 241),
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );
    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 8.0,
                      left: 0.0,
                      child: const Text(
                        'Retrô Sabor\nda Vovó',
                        style: TextStyle(
                            fontSize: 30.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model){
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Olá, ${!model.isLoggedIn()
                                    ? ""
                                    : model.userData["name"]}",
                                style: TextStyle(
                                    fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                child: Text(
                                  !model.isLoggedIn()
                                    ? 'Entre ou cadastre-se >'
                                    : 'Sair',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                onTap: () {
                                  if (!model.isLoggedIn()){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context)=> LoginScreen())
                                    );
                                  }
                                  else
                                    model.signOut();
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, 'Início', pageController, pageHome),
              DrawerTile(Icons.list, 'Produtos', pageController, pageProducts),
              DrawerTile(Icons.location_on, 'Nossas lojas', pageController,
                  pageStores),
              DrawerTile(Icons.playlist_add_check, 'Meus Pedidos',
                  pageController, pageOrders),
            ],
          ),
        ],
      ),
    );
  }
}
