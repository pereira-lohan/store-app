import 'package:applojavirtual/models/user_model.dart';
import 'package:applojavirtual/screens/signup_screen.dart';
import 'package:applojavirtual/widgets/custom_circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>  {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
        title: Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text('Criar Conta',
              style: TextStyle(fontSize: 15.0),
            ),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignUpScreen())
              );
            },
          )
        ],
      ),
      //Uma forma para acessar o modelo
      //Será Refeito caso tenha alguma modificação
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if (model.isLoading)
            return CustomCircularProgressIndicator();
          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: "E-mail"
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text){
                    if (text.isEmpty || !text.contains("@") || text == null)
                      return "E-mail inválido";
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        hintText: "Senha"
                    ),
                    obscureText: true,
                    validator: (text){
                      if (text.isEmpty || text == null || text.length < 6)
                        return "Senha inválida!";
                      return null;
                    }
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      if (_emailController.text.isEmpty
                          || _emailController.text == null){
                        _showCustomSnackBar(
                            text: 'Insira seu E-mail para recuperação',
                            color: Colors.redAccent);
                      } else {
                        model.recoverPass(_emailController.text);
                        _showCustomSnackBar(
                            text: 'Confira seu E-mail',
                            color: Theme.of(context).primaryColor);
                      }
                    },
                    child: Text('Esqueci minha senha',
                      textAlign: TextAlign.right,
                    ),
                    textColor: Theme.of(context).primaryColor,
                    //remover o padding padrão
                    padding: EdgeInsets.zero,
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text('Entrar',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()){
                          model.signIn(
                              email: _emailController.text,
                              password: _passwordController.text,
                              onSuccess: _onSuccess,
                              onFailed: _onFailed
                          );
                        }
                      },
                    )
                ),
              ],
            ),
          );
        },
      )
    );
  }

  void _onSuccess(){
    Navigator.of(context).pop();
  }
  void _onFailed(){
    _showCustomSnackBar(
        text: 'Falha ao Efetuar o Login',
        color: Colors.redAccent);
    Future.delayed(Duration(seconds: 2)).then((_){
      Navigator.of(context).pop();
    });
  }

  void _showCustomSnackBar({@required String text, @required Color color}){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: color,
          duration: Duration(seconds: 2),
        )
    );
  }
}
