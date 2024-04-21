 
import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart';

import 'authProvider.dart'; 
 
class LoginScreen extends StatefulWidget { 
  @override 
  _LoginScreenState createState() => _LoginScreenState(); 
} 
 
class _LoginScreenState extends State<LoginScreen> { 
  var emailController = TextEditingController(); 
  var passwordController = TextEditingController(); 
  var confirmPasswordController = TextEditingController(); 
   
 
  var authenticationMode = 0; 
  // 0 for login and 1 for signup. 
  // when 0: only email and password fields appear + button login + button sign up instead 
  // when 1: email and password and confimp password appear + button sign up + button login instead 
 
  void toggleAuthMode() { 
    if (authenticationMode == 0) { 
      setState(() { 
        authenticationMode = 1; 
      }); 
    } else { 
      setState(() { 
        authenticationMode = 0; 
      }); 
    } 
  } 
  @override 
  Widget build(BuildContext context) { 
     
    
    return Scaffold( 
      body: Container( 
        width: double.infinity, 
        height: 400, 
        margin: EdgeInsets.only(top: 100, left: 10, right: 10), 
        child: Card( 
          elevation: 5, 
          shape: RoundedRectangleBorder( 
            borderRadius: BorderRadius.circular(20), 
          ), 
          child: Padding( 
            padding: const EdgeInsets.all(8.0), 
            child: Column( 
              children: [ 
                Center( 
                  child: Text( 
                    "Afkar", 
                    style: TextStyle(fontSize: 30), 
                  ), 
                ), 
                TextField( 
                  decoration: InputDecoration(labelText: "Email"), 
                  controller: emailController, 
                  keyboardType: TextInputType.emailAddress, 
                ), 
                TextField( 
                  decoration: InputDecoration(labelText: "Password"), 
                  controller: passwordController, 
                  obscureText: true, 
                ), 
                if (authenticationMode == 1) 
                  TextField( 
                    decoration: InputDecoration(labelText: "Confirm Password"), 
                    controller: confirmPasswordController, 
                    obscureText: true, 
                  ), 
                ElevatedButton( 
                  onPressed: () { 
                    loginORsignup(); 
                  }, 
                  child: (authenticationMode == 1) 
                      ? Text("Sign up") 
                      : Text("Login"), 
  ), 
                TextButton( 
                  onPressed: () { 
                    toggleAuthMode(); 
                  }, 
                  child: (authenticationMode == 1) 
                      ? Text("Login instead") 
                      : Text("Sign up instead"), 
                ), 
              ], 
            ), 
          ), 
        ), 
      ), 
    ); 
  } 
 
  void loginORsignup() async { 
    var authprov = Provider.of<AuthProvider>(context, listen: false); 
    var email = emailController.text.trim(); 
    var password = passwordController.text.trim(); 
 
    if (authenticationMode == 1) { 
      var successOrError = await authprov.signup(em: email, pass: password); 
      if (successOrError == "success") { 
      Navigator.of(context).pop(); 
      Navigator.of(context).pushNamed('/IdeasRoute'); 
      } else if (successOrError.contains("EMAIL_EXISTS")) { 
 
        final snackBar = SnackBar( 
          content: Text('Email already exists'), 
          backgroundColor: Colors.red, 
        ); 
 
        ScaffoldMessenger.of(context).showSnackBar(snackBar); 
      } 
 
      //Navigator.of(context).pushNamed('/IdeasRoute'); 
    } else { 
      var successOrError = await authprov.signin(em: email, pass: password); 
      if (successOrError == "success") { 
      Navigator.of(context).pop(); 
      Navigator.of(context).pushNamed('/IdeasRoute'); 
        // do action for success, maybe navigate to ideas page. 
      } else if (successOrError.contains("EMAIL_NOT_FOUND")) { 
        final snackBar = SnackBar( 
          content: Text('Email was not found'), 
  backgroundColor: Colors.red, 
        ); 
 
        ScaffoldMessenger.of(context).showSnackBar(snackBar); 
      } else if (successOrError.contains("INVALID_PASSWORD")) { 
        final snackBar = SnackBar( 
          content: Text('Incorrect password'), 
          backgroundColor: Colors.red, 
        ); 
 
        ScaffoldMessenger.of(context).showSnackBar(snackBar); 
      } 
 
       
 
    } 
  } 
}