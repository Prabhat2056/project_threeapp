


//without animation
// import 'package:flutter/material.dart';
// import 'package:project_etb/login/login_page.dart';
// import 'package:project_etb/login/signup_page.dart';

// class FirstPage extends StatelessWidget {
//   const FirstPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           padding: const EdgeInsets.all(10),
//           margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // 1️⃣ Image Container (Top)
//               Container(
//                 height: 400,
//                 alignment: Alignment.center,
//                 child: Hero(
//                   tag: 'first-hero',
//                   child: Image.asset(
//                     "image/first.png",
//                     height: 270, // ⬆ Bigger image
//                   ),
//                 ),
//               ),

//               // 2️⃣ Text Container (Just above Buttons)
//               // 2️⃣ Text Container - Moved closer to buttons
//               Column(
//                 children: const [
//                   Text(
//                     "Build Awesome Apps",
//                     style: TextStyle(
//                       fontSize: 36, // Slightly bigger text for heading
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     "Let's put your creativity on the",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 2),
//                   Text(
//                     "development highway.",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),

//               // 3️⃣ Buttons Container - Positioned at bottom
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Login Button
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 10),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const LoginPage(),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: Colors.blueGrey,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 30,
//                           vertical: 15,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         elevation: 5,
//                       ),
//                       child: const Text(
//                         "LOGIN",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Signup Button
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 10),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const SignupPage(),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         foregroundColor: Colors.blueGrey,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 30,
//                           vertical: 15,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         elevation: 5,
//                       ),
//                       child: const Text(
//                         "SIGNUP",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//with animation
import 'package:flutter/material.dart';
import 'package:project_etb/login/login_page.dart';
import 'package:project_etb/login/signup_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _imageSlideAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _imageSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3), // Slide slightly from top
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3), // Slide slightly from bottom
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Start animation when page loads
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1️⃣ Image with Slide + Fade
              SlideTransition(
                position: _imageSlideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    height: 500,
                    alignment: Alignment.center,
                    child: Hero(
                      tag: 'first-hero',
                      child: Image.asset(
                        "image/first.png",
                        height: 280,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),

              // 2️⃣ Text with Slide + Fade
              SlideTransition(
                position: _textSlideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: const [
                      Text(
                        "Build Awesome Apps",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Let's put your creativity on the",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 2),
                      Text(
                        "development highway.",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              //const SizedBox(height: 10),

              // 3️⃣ Buttons (no animation to keep them snappy)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: [
                  // Login Button
                  Container(
                    
                    margin: const EdgeInsets.symmetric(vertical: 50),
                    
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

                  // Signup Button
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


            ],
          ),
        ),
      ),
    );
  }
}


