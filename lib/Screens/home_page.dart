import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/';
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Bem vindo ao CCB',
                  style: TextStyle(fontSize: 22),),
            
            Text('Controle Computadorizado de Bordados',
                  style: TextStyle(fontSize: 22),),
                
          ]
        )

      ),
      
    );
  }
}