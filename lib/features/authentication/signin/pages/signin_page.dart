import 'package:bookapin/components/theme_data.dart';
import 'package:bookapin/features/authentication/signin/bloc/signin_bloc.dart';
import 'package:bookapin/features/authentication/signin/bloc/signin_event.dart';
import 'package:bookapin/features/authentication/signin/bloc/signin_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool isVisible = false;
  bool isPasswordValid = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  bool _isPasswordValid(String value) {
    final hasMinLength = value.length >= 8;
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasNumber = RegExp(r'[0-9]').hasMatch(value);

    return hasMinLength && hasLetter && hasNumber;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInLoading) {
        } else if (state is SignInSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Hello ${state.user.username}. Welcome back!", style:AppTheme.bodyStyle)),
          );
          state.user.role == 'Customer'? Navigator.pushReplacementNamed(context, '/home') : Navigator.pushReplacementNamed(context, '/dashboard');
        } else if (state is SignInError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
    child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png"),
            const SizedBox(height: 40),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.72,
              child: Column(
                children: [
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
                      onChanged: (value) {
                        setState(() {
                          isPasswordValid = _isPasswordValid(value.trim());
                        });
                      },
                      decoration: AppTheme.inputDecoration("Password").copyWith(
                        errorText: isPasswordValid ? null : 'Password should be 8 characters and contains number and letters',
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
                        "Don't have an account? ",
                        style: theme.textTheme.bodyLarge,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: Text(
                          "Sign Up",
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
                      decoration: AppTheme.buttonDecorationPrimary,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<SignInBloc>().add(
                            SignInWithEmailEvent(
                              email: emailController.text.trim(), 
                              password: passwordController.text.trim()
                            )
                          );
                        },
                        child: Text(
                          "Sign In",
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
                  "Or sign in with ",
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap:(){
                    context.read<SignInBloc>().add(SignInWithGoogleEvent());
                  },
                  child: Container(
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
          ],
        ),
      ),
    )
    );
  }
}