import 'package:bookapin/components/theme_data.dart';
import 'package:bookapin/features/authentication/signup/bloc/signup_bloc.dart';
import 'package:bookapin/features/authentication/signup/bloc/signup_event.dart';
import 'package:bookapin/features/authentication/signup/bloc/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isVisible = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpLoading) {
        } else if (state is SignUpSuccess) {
          Navigator.pushReplacementNamed(context, '/signin');
        } else if (state is SignUpError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
    child: Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child:Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset("assets/logo.png"),
                const SizedBox(height: 40),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.72,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Username",
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Container(
                        decoration: AppTheme.inputContainerDecoration,
                        clipBehavior: Clip.antiAlias,
                        child: TextField(
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                          decoration: AppTheme.inputDecoration("Username"),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Email",
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Container(
                        decoration: AppTheme.inputContainerDecoration,
                        clipBehavior: Clip.antiAlias,
                        child: TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: AppTheme.inputDecoration("Email"),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Password",
                          style: theme.textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Container(
                    decoration: AppTheme.inputContainerDecoration,
                    clipBehavior: Clip.antiAlias,
                    child: TextField(
                      controller: passwordController,
                      obscureText: !isVisible,
                      decoration: AppTheme.inputDecoration("Password").copyWith(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          }, 
                          icon: Icon(
                            isVisible ? Icons.visibility_off : Icons.visibility,
                          )
                        )
                      ),
                    ),
                  ),
                      const SizedBox(height: 16),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Have an account? ",
                            style: theme.textTheme.bodyLarge,
                          ),
                          GestureDetector(
                            onTap:(){
                              Navigator.pushReplacementNamed(context, "/signin");
                            },
                            child: Text(
                            "Sign In",
                            style: AppTheme.linkStyle,
                          ),
                          )
                        ],
                      ),
                      const SizedBox(height: 40),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: Container(
                          decoration: AppTheme.buttonDecoration,
                          child: ElevatedButton(
                            onPressed: () {
                          context.read<SignUpBloc>().add(
                            SignUpWithUsernameEmailEvent(
                              username: usernameController.text.trim(),
                              email: emailController.text.trim(), 
                              password: passwordController.text.trim()
                            )
                          );
                        },
                            child: Text(
                              "Sign Up",
                              style: theme.textTheme.labelLarge,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                
                Column(
                  children: [
                    Text(
                      "Or sign up with ",
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: (){
                        context.read<SignUpBloc>().add(SignUpWithGoogleEvent());
                      },
                      child:  Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        "assets/google.svg",
                        width: 32,
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                    ),
                    )
                  ],
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      )
    )
    );
  }
}