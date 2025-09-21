

// import "package:flutter/material.dart";
// import "package:project_etb/login/login_page.dart";
// import "package:project_etb/login/signup_page.dart";

// class FirstPage extends StatelessWidget {
//   const FirstPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // 👇 Image at the top
//               Padding(
//                 padding: const EdgeInsets.only(top: 100),
                

//                 child: Hero(
//                   tag: 'first-hero', // unique tag for hero animation
//                   child: Image.asset("image/first.png", height: 250),
//                 ),
//                 // child: Image.asset(
//                 //   "image/first.png",
//                 //   height: 350,
//                 // ),
//               ),
//               const SizedBox(height: 50),

              

//               // 👇 Bottom Section (Text + Buttons)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 30),
//                 child: Column(
//                   children: [
//                     const Text(
//                       "Build Awesome Apps",
//                       style: TextStyle(
//                         fontSize: 35,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 2),

//                     const Text(
//                       "Let's put your creativity on the",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 2),

//                     const Text(
//                       "development highway.",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 30),

//                     // 👇 Row with two buttons
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             //Navigator.pushNamed(context, '/login');
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const LoginPage(),
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             foregroundColor: Colors.blueGrey,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 30,
//                               vertical: 15,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             elevation: 5,
//                           ),
//                           child: const Text(
//                             "LOGIN",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 20), // spacing between buttons
//                         ElevatedButton(
//                           onPressed: () {
//                             //Navigator.pushNamed(context, '/signup');
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const SignupPage(),
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white,
//                             foregroundColor: Colors.blueGrey,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 30,
//                               vertical: 15,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5),
//                             ),
//                             elevation: 5,
//                           ),
//                           child: const Text(
//                             "SIGNUP",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:project_etb/login/login_page.dart';
import 'package:project_etb/login/signup_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 1️⃣ Image Container
              Container(
                height: 250,
                alignment: Alignment.center,
                child: Hero(
                  tag: 'first-hero',
                  child: Image.asset(
                    "image/first.png",
                    height: 250,
                  ),
                ),
              ),
              

              // 2️⃣ Text Container
              Container(
                child: Column(
                  children: const [
                    Text(
                      "Build Awesome Apps",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Let's put your creativity on the",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 2),
                    Text(
                      "development highway.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              

              // 3️⃣ Buttons Container
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Login Button Container
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blueGrey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    // Signup Button Container
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blueGrey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "SIGNUP",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
