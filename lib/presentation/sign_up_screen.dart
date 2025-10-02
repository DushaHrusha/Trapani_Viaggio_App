import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../core/adaptive_size_extension.dart';
import '../core/constants/base_colors.dart';
import '../core/constants/custom_gradient_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimations = List.generate(3, (index) {
      final start = 0.2 + (index * 0.2);
      final end = start + 0.2;
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            _buildHeaderImage(context),
            _buildContentContainer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context) {
    return Image.asset(
      'assets/images/river.jpg',
      height: context.adaptiveSize(500),
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildContentContainer(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.adaptiveSize(298)),
      child: Container(
        decoration: BoxDecoration(
          color: BaseColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(context.adaptiveSize(32)),
          ),
        ),
        constraints: BoxConstraints.expand(
          width: MediaQuery.of(context).size.width,
          height:
              MediaQuery.of(context).size.height - context.adaptiveSize(298),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBackButton(context),
              _buildTitle(context),
              _buildPhoneInput(context),
              SizedBox(height: context.adaptiveSize(22)),
              _buildDividerWithText(context),
              SizedBox(height: context.adaptiveSize(18)),
              _buildSocialIcons(context),
              SizedBox(height: context.adaptiveSize(95)),
              _buildSignUpButton(context),
              SizedBox(height: context.adaptiveSize(26)),
              _buildLoginPrompt(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return _buildFadeTransition(
      0,
      Padding(
        padding: EdgeInsets.only(
          left: context.adaptiveSize(25),
          top: context.adaptiveSize(25),
        ),
        child: GestureDetector(
          onTap: () => context.canPop() ? context.pop() : context.go("/home"),
          child: Icon(
            Icons.arrow_back,
            size: context.adaptiveSize(24),
            color: const Color.fromARGB(255, 109, 109, 109),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return _buildFadeTransition(
      0,
      Padding(
        padding: EdgeInsets.only(
          left: context.adaptiveSize(25),
          top: context.adaptiveSize(17),
        ),
        child: Text(
          'Sign Up',
          style: context.adaptiveTextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: const Color.fromARGB(255, 109, 109, 109),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInput(BuildContext context) {
    return _buildFadeTransition(
      1,
      Padding(
        padding: EdgeInsets.only(
          left: context.adaptiveSize(30),
          top: context.adaptiveSize(24),
          right: context.adaptiveSize(30),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.adaptiveSize(30)),
            border: Border.all(color: Colors.grey),
          ),
          child: Row(
            children: [
              _buildRegionDropdown(context),
              Container(
                width: 1,
                height: context.adaptiveSize(50),
                color: const Color.fromARGB(255, 224, 224, 224),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  height: context.adaptiveSize(50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(context.adaptiveSize(30)),
                    ),
                  ),
                  child: const PhoneNumber(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegionDropdown(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: context.adaptiveSize(100),
      height: context.adaptiveSize(50),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 235, 241, 244),
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(context.adaptiveSize(30)),
        ),
      ),
      child: DropdownButton<String>(
        value: '+39',
        style: context.adaptiveTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: BaseColors.text,
        ),
        items: ['+39', '+7', '+44', '+91']
            .map(
              (value) => DropdownMenuItem<String>(
                value: value,
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(right: context.adaptiveSize(8)),
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: BaseColors.text,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: (String? newValue) {},
        underline: Container(),
        icon: SvgPicture.asset(
          'assets/icons/Vector.svg',
          height: context.adaptiveSize(6),
          color: BaseColors.text,
        ),
      ),
    );
  }

  Widget _buildDividerWithText(BuildContext context) {
    return _buildFadeTransition(
      1,
      Row(
        children: [
          Expanded(
            child: Divider(
              color: const Color.fromARGB(255, 224, 224, 224),
              indent: context.adaptiveSize(30),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.adaptiveSize(10)),
            child: Text(
              'or',
              style: context.adaptiveTextStyle(
                fontSize: 14,
                color: const Color.fromARGB(255, 224, 224, 224),
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: const Color.fromARGB(255, 224, 224, 224),
              endIndent: context.adaptiveSize(30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcons(BuildContext context) {
    final icons = [
      'assets/images/apple.png',
      'assets/images/google.png',
      'assets/images/facebook.png',
      'assets/images/at sign.png',
    ];

    return _buildFadeTransition(
      2,
      Padding(
        padding: EdgeInsets.symmetric(horizontal: context.adaptiveSize(27)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: icons
              .map((icon) => _buildSocialIcon(icon, context))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String imagePath, BuildContext context) {
    return CircleAvatar(
      radius: context.adaptiveSize(24),
      backgroundColor: const Color.fromARGB(255, 235, 241, 244),
      child: Image.asset(imagePath),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Padding(
      padding: context.adaptivePadding(
        const EdgeInsets.symmetric(horizontal: 30.0),
      ),
      child: _buildFadeTransition(
        2,
        const CustomGradientButton(text: "Sign up", path: ""),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return _buildFadeTransition(
      2,
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Have an account? ',
            style: context.adaptiveTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color.fromARGB(255, 109, 109, 109),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Log in',
              style: context.adaptiveTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: BaseColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFadeTransition(int animationIndex, Widget child) {
    return FadeTransition(
      opacity: _fadeAnimations[animationIndex],
      child: child,
    );
  }
}

// PhoneNumber виджет
class PhoneNumber extends StatefulWidget {
  const PhoneNumber({super.key});

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  final TextEditingController _phoneController = TextEditingController();
  String _lastText = '';

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_formatPhoneNumber);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _formatPhoneNumber() {
    final cleanText = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanText.length > 10) {
      _phoneController.value = TextEditingValue(
        text: _lastText,
        selection: TextSelection.collapsed(offset: _lastText.length),
      );
      return;
    }

    final formatted = _formatCleanText(cleanText);
    final newOffset = _calculateCursorPosition(formatted);

    _phoneController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newOffset),
    );
    _lastText = formatted;
  }

  String _formatCleanText(String cleanText) {
    if (cleanText.isEmpty) return '';
    if (cleanText.length <= 3) return '($cleanText';
    if (cleanText.length <= 6) {
      return '(${cleanText.substring(0, 3)}) ${cleanText.substring(3)}';
    }
    if (cleanText.length <= 8) {
      return '(${cleanText.substring(0, 3)}) ${cleanText.substring(3, 6)}-${cleanText.substring(6)}';
    }
    return '(${cleanText.substring(0, 3)}) ${cleanText.substring(3, 6)}-${cleanText.substring(6, 8)}-${cleanText.substring(8)}';
  }

  int _calculateCursorPosition(String formatted) {
    final cursorPosition = _phoneController.selection.baseOffset;
    if (cursorPosition > formatted.length) return formatted.length;
    if (_lastText.length < formatted.length &&
        cursorPosition == _lastText.length) {
      return formatted.length;
    }
    return cursorPosition.clamp(0, formatted.length);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlign: TextAlign.center,
      controller: _phoneController,
      decoration: const InputDecoration(
        hintText: '(000) 000-00-00',
        border: InputBorder.none,
        hintStyle: TextStyle(
          fontSize: 16,
          color: BaseColors.text,
          fontWeight: FontWeight.w400,
        ),
      ),
      keyboardType: TextInputType.phone,
    );
  }
}
