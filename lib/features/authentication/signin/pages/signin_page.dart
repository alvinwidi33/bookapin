import 'dart:async';

import 'package:bookapin/components/theme_data.dart';
import 'package:bookapin/features/authentication/signin/animation/animation_state.dart';
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
  AuthAnimState authState = AuthAnimState.idle;
    Timer? _resetAnimTimer;
Timer? _navigationTimer;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

@override
void dispose() {
  _resetAnimTimer?.cancel();
  _navigationTimer?.cancel();
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
          setState((){
            authState = AuthAnimState.loading;
          });
        } else if (state is SignInSuccess) {
          setState(() {
            authState = AuthAnimState.success;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Hello ${state.user.username}")),
          );

          _navigationTimer = Timer(
            const Duration(milliseconds: 1200),
            () {
              if (!mounted) return;

              final route = state.user.role == 'Customer'
                  ? '/home'
                  : '/dashboard';

              Navigator.pushReplacementNamed(context, route);
            },
          );
        } else if (state is SignInError) {
          setState((){
            authState = AuthAnimState.error;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        _resetAnimTimer = Timer(
          const Duration(seconds: 2),
          () {
            if (mounted) {
              setState(() => authState = AuthAnimState.idle);
            }
          },
        );
      },
    child: Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child:Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Image.asset("assets/logo.png"),
                  const SizedBox(height: 40),
                  AuthIndicator(state: authState), 
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.84,
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
                          key: const Key('email_text_field'),
                          decoration: AppTheme.inputContainerDecoration,
                          clipBehavior: Clip.antiAlias,
                          child: TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (_){
                              setState((){
                                authState = AuthAnimState.typingEmail;
                              });
                            },
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
                          key: const Key('password_text_field'),
                          decoration: AppTheme.inputContainerDecoration,
                          clipBehavior: Clip.antiAlias,
                          child: TextField(
                            controller: passwordController,
                            obscureText: !isVisible,
                            onChanged: (value) {
                              setState(() {
                                authState = AuthAnimState.typingPassword;
                                isPasswordValid = _isPasswordValid(value.trim());
                              });
                            },
                            decoration: AppTheme.inputDecoration("Password").copyWith(
                              errorText: isPasswordValid ? null : 'Password should be 8 characters and contains number and letters',
                              errorMaxLines: 2,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                }, 
                                icon: Icon(
                                  isVisible ? Icons.visibility_off : Icons.visibility,
                                ), style: ButtonStyle(iconColor: WidgetStateProperty.all(AppTheme.iconColor)),
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
                              key: const Key('signin_button'),
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
                  const SizedBox(height: 20)
                ],
              ),
            ),
          )
        ) 
      )
    );
  }
}