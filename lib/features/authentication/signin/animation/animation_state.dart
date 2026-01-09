import 'package:bookapin/components/theme_data.dart';
import 'package:flutter/material.dart';

enum AuthAnimState {
  idle,
  typingEmail,
  typingPassword,
  loading,
  success,
  error,
}

class AuthIndicator extends StatefulWidget {
  final AuthAnimState state;

  const AuthIndicator({super.key, required this.state});

  @override
  State<AuthIndicator> createState() => _AuthIndicatorState();
}

class _AuthIndicatorState extends State<AuthIndicator>
    with SingleTickerProviderStateMixin {
    late AnimationController _controller;
    late Animation<double> _shake;
    late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scale = Tween(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _shake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -6.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 1),
    ]).animate(_controller); 
  }


  @override
  void didUpdateWidget(covariant AuthIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.state != widget.state &&
        widget.state != AuthAnimState.idle) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    String text = "";

    switch (widget.state) {
      case AuthAnimState.typingEmail:
        icon = Icons.email;
        color = AppTheme.primaryPurple;
        text = "Typing email";
        break;
      case AuthAnimState.typingPassword:
        icon = Icons.lock;
        color = AppTheme.googleBlue;
        text = "Typing password";
        break;
      case AuthAnimState.loading:
        icon = Icons.lock_outline;
        color = AppTheme.gradientEnd;
        text = "Loading";
        break;
      case AuthAnimState.success:
        icon = Icons.check_circle;
        color = Colors.limeAccent;
        text = "Login Success";
        break;
      case AuthAnimState.error:
        icon = Icons.lock;
        color = AppTheme.iconColor;
        text = "Ups error";
        break;
      default:
        icon = Icons.lock_open;
        color = Colors.grey;
    }

    return AnimatedOpacity( 
      duration: const Duration(milliseconds: 300),
      opacity: widget.state == AuthAnimState.idle ? 0 : 1,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              widget.state == AuthAnimState.error ? _shake.value : 0,
              0,
            ),
            child: Transform.scale(
              scale: _scale.value,
              child: Column(
                children: [
                  AnimatedContainer( 
                    duration: const Duration(milliseconds: 400),
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha:0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(icon, size: 42, color: color),
                        if (widget.state == AuthAnimState.loading)
                          const CircularProgressIndicator(strokeWidth: 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: widget.state == AuthAnimState.idle ? 0 : 1,
                child: Text(
                  text,
                  style: AppTheme.subtitleDetail.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
