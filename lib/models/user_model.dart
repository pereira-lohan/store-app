import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class UserModel extends Model {
  //Um model é um objeto que armazenará os estados de algo,
  //neste caso, irá armazenar o estado atual do usuário e as funções
  //para modificar o estado
  bool isLoading = false;

  //Como é um Singleton e queremos deixar menos verboso, passamos para uma
  //variável a instância do FirebaseAuth
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  //VoidCallback são funções para ajudar a comunicação entre dois widgets,
  //Neste caso, utilizaremos para efetuar algo quando obtivermos ao efetuar o
  //SignUp ou mesmo tivermos alguma falha
  //o required é para definir que um parâmetro opcional é requerido

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String password,
      @required VoidCallback onSuccess,
      @required VoidCallback onFailed}) {
    notifyListeners(isLoading: true);

    _auth
        .createUserWithEmailAndPassword(
            email: userData['email'], password: password)
        .then((user) async {
      firebaseUser = user.user;
      await _saveUserData(userData);
      onSuccess();
      notifyListeners(isLoading: false);
    }).catchError((error) {
      onFailed();
      notifyListeners(isLoading: false);
    });
  }

  void signIn(
      {@required String email,
      @required String password,
      @required VoidCallback onSuccess,
      @required VoidCallback onFailed}) {
    notifyListeners(isLoading: true);

    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((user) async {
      firebaseUser = user.user;
      await _loadCurrentUser();
      onSuccess();
    }).catchError((error) {
      onFailed();
    });
    notifyListeners(isLoading: false);
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners(isLoading: false);
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() => this.firebaseUser != null;

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  //Uma pequena burlagem no override, para adicionar um parâmetro no método
  //Neste caso, coloquei como requerido e como opcional
  @override
  void notifyListeners({@required bool isLoading}) {
    super.notifyListeners();
    this.isLoading = isLoading;
  }

  Future<Null> _loadCurrentUser() async{
    if (firebaseUser == null)
      firebaseUser = await _auth.currentUser();
    if (firebaseUser != null && userData['name'] == null){
      DocumentSnapshot doc =
          await Firestore.instance.collection('users')
              .document(firebaseUser.uid).get();
      this.userData = doc.data;
      notifyListeners(isLoading: false);
    }

  }
}
