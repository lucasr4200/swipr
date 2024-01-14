import 'package:flutter/material.dart';
import 'package:swipr/movies.dart';
import 'main.dart';
import 'users.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // State variables here (e.g., TextEditingControllers)

final _usernameController = TextEditingController();
final _passwordController = TextEditingController();


@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF333333),
    appBar: AppBar(
      backgroundColor: const Color(0xFF1C1C1C),
      title: const Text(
        'Login',
        style: TextStyle(color: Color(0xFFFFFFFF)),
      ),
    ),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _usernameController,
            style: TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Username',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _passwordController,
            style: TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF4169E1)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            onPressed: () {
              String username = _usernameController.text;
              String password = _passwordController.text;
              if (checkLogin(username, password)) {
                // Login successful
                print("Login Successful");
                _login();
                // User user_logged_in = users.firstWhere((user) => user.username == username && user.password == password);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userLoggedIn: user_logged_in)),);
              } else {
                // Login failed
                print("Login Failed");
              }
            },
            child: const Text('Login',
            style: TextStyle(color: Colors.white),
            ),
          ),
          // Add other widgets here...
        ],
      ),
    ),
  );
}



  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool checkLogin(String username, String password) {
  return users.any((user) => user.username == username && user.password == password);
}

void _login() {
    User userLoggedIn = users.firstWhere((user) => user.username == _usernameController.text && user.password == _passwordController.text);
    Set<String> selectedPreferences = {};
    fetchMovies(userLoggedIn, selectedPreferences).then((movies) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(userLoggedIn: userLoggedIn, movie: movies[0]),
        ),
      );
    }).catchError((e) {
      print('Error: $e');
    });
  }
  

}

