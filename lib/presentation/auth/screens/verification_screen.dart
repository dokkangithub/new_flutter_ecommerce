import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationScreen extends StatefulWidget {
  final bool isEmail;
  final String contactInfo;
  final int otpLength;

  const VerificationScreen({
    Key? key,
    this.isEmail = true,
    required this.contactInfo,
    this.otpLength = 4,
  }) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> with SingleTickerProviderStateMixin {
  TextEditingController otpController = TextEditingController();
  bool hasError = false;
  String currentText = "";
  bool isButtonEnabled = false;
  int timerSeconds = 30;
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    startTimer();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        setState(() {
          if (timerSeconds > 0) {
            timerSeconds--;
          } else {
            _timer?.cancel();
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.width > 600;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 64 : 24,
              vertical: 32,
            ),
            child: FadeTransition(
              opacity: _fadeInAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: isTablet ? 100 : 80,
                      width: isTablet ? 100 : 80,
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: isTablet ? 50 : 40,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),

                  SizedBox(height: isTablet ? 48 : 32),

                  // Title
                  Text(
                    'Verification',
                    style: TextStyle(
                      fontSize: isTablet ? 32 : 24,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Subtitle
                  Text(
                    'Enter the verification code sent to\n${widget.isEmail ? 'email' : 'phone'}: ${widget.contactInfo}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),

                  SizedBox(height: isTablet ? 48 : 32),

                  // OTP Field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: isTablet ? 48 : 16),
                    child: PinCodeTextField(
                      appContext: context,
                      length: widget.otpLength,
                      controller: otpController,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(12),
                        fieldHeight: isTablet ? 64 : 56,
                        fieldWidth: isTablet ? 64 : 56,
                        activeFillColor: hasError ? Colors.red.shade100 : theme.colorScheme.surface,
                        inactiveFillColor: theme.colorScheme.surface,
                        selectedFillColor: theme.colorScheme.surface,
                        activeColor: hasError ? Colors.red : theme.primaryColor,
                        inactiveColor: theme.dividerColor,
                        selectedColor: theme.primaryColor,
                      ),
                      cursorColor: theme.primaryColor,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        setState(() {
                          currentText = value;
                          isButtonEnabled = value.length == widget.otpLength;
                          hasError = false;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Error Text
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: hasError ? 1 : 0,
                    child: Text(
                      "Please enter a valid verification code",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: isTablet ? 14 : 12,
                      ),
                    ),
                  ),

                  SizedBox(height: isTablet ? 48 : 32),

                  // Verify Button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: isTablet ? 60 : 56,
                    child: ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () {
                        if (currentText.length != widget.otpLength) {
                          setState(() {
                            hasError = true;
                          });
                        } else {
                          // Handle verification logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Verification successful!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: theme.primaryColor,
                        disabledBackgroundColor: theme.disabledColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Verify',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Resend Timer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive the code? ",
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      timerSeconds > 0
                          ? Row(
                        children: [
                          Text(
                            "Resend in ",
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                          Text(
                            "$timerSeconds seconds",
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      )
                          : TextButton(
                        onPressed: () {
                          // Resend OTP logic
                          setState(() {
                            timerSeconds = 30;
                          });
                          startTimer();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("OTP resent successfully!"),
                            ),
                          );
                        },
                        child: Text(
                          "Resend",
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}