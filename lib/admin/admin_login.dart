import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:demo/admin/report_fetch.dart';
import 'package:demo/admin/admin_home_page.dart';

class LoginAdmin extends StatefulWidget {
  const   LoginAdmin({Key? key}) : super(key: key);

  @override
  State<LoginAdmin> createState() => _LoginAdminState();
}

class _LoginAdminState extends State<LoginAdmin> {
  bool _passwordVisible = false;
  bool? _isChecked = false;
  TextEditingController _adminIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Predefined admin ID and password
  int _adminId = 123;
  int _adminPassword = 123;

  @override
  void dispose() {
    _adminIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image.asset("assets/images/login.png"),
        toolbarHeight: 150,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        child: Image.asset("assets/images/login_cont.png"),
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 110),
                      ),
                      Container(
                        child: Image.asset("assets/images/boy_login.png"),
                        width: 200,
                        height: 200,
                        margin: EdgeInsets.only(left: 120, bottom: 0, top: 20),
                      ),
                      Container(
                        width: 350,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: _adminIdController,
                              autocorrect: true,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                labelText: "Admin ID",
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_passwordVisible,
                              autocorrect: true,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                labelText: "Password",
                                suffixIcon: IconButton(
                                  icon: Icon(_passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(top: 200, left: 30),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: (newValue) {
                              setState(() {
                                _isChecked = newValue;
                              });
                            },
                          ),
                          Text(
                            "Remember Me",
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (context) => ForgotPass()),
                      //     );
                      //   },
                      //   child: Text(
                      //     "Forgot Password?",
                      //     style: TextStyle(fontSize: 17),
                      //   ),
                      // )
                    ],
                  ),
                  Container(
                    height: 50,
                    width: 380,
                    margin: EdgeInsets.only(top: 50),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _login();
                      },
                      icon: Icon(
                        Icons.login,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Login",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(HexColor("146c94")),
                      ),
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

  void _login() {
    int enteredId = int.tryParse(_adminIdController.text) ?? 0;
    int enteredPassword = int.tryParse(_passwordController.text) ?? 0;

    if (enteredId == _adminId && enteredPassword == _adminPassword) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful'),
          duration: Duration(seconds: 2),
        ),
      );


      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Admin_Home_Page()),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Incorrect admin ID or password. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
