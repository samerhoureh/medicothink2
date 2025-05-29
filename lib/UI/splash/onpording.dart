import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  final List<_OnboardData> _slides = const [
    _OnboardData(
      title: 'Medical knowledge at\nyour fingertips',
      subtitle:
          'There are many variations of passages\nof Lorem Ipsum available, but the\nmajority have suffered.',
      botImage: 'assets/images/medicom.png',
    ),
    _OnboardData(
      title: 'Medical knowledge at\nyour fingertips',
      subtitle:
          'If you are going to use a passage of\nLorem Ipsum, you need to be sure the\nmiddle of text.',
      botImage: 'assets/images/medicom.png',
    ),
    _OnboardData(
      title: 'Medical knowledge at\nyour fingertips',
      subtitle:
          'If you are going to use a passage of\nLorem Ipsum, you need to be sure there\nthe middle of text.',
      botImage: 'assets/images/medicom.png',
    ),
     _OnboardData(
      title: 'Medical knowledge at\nyour fingertips',
      subtitle:
          'If you are going to use a passage of\nLorem Ipsum, you need to be sure there\nthe middle of text.',
      botImage: 'assets/images/medicom.png',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Indicator dot.
  Widget _dot(bool active) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 8,
        width: 8,
        decoration: BoxDecoration(
          color: active ? const Color(0xFF20A9C3) : const Color(0xFFD9D9D9),
          shape: BoxShape.circle,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Image.asset(
                'assets/images/splash/medico_logo.jpg',
                height: 150,
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _slides.length,
                itemBuilder: (_, i) {
                  final slide = _slides[i];
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Image.asset(
                          slide.botImage,
                          height: size.height * 0.30,
                        ),

                        // title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            slide.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                              color: Color(0xFF001C46), 
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),

                        Container(
                          height: 4,
                          width: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFFB6BEC8),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 7),

                        // description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            slide.subtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.4,
                              color: Color(0xFF7F8C99),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // page indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            _slides.length,
                            (index) => _dot(index == _page),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Container(
             width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
              decoration: const BoxDecoration(
                color: Color(0xFF20A9C3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Let's Get Started!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF001C46),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Navigate to login screen
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'REGISTER (OR) LOGIN',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF001C46),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (_page < _slides.length - 1) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.pushReplacementNamed(context, '/onboarding2');
                        }
                      },
                      child: const Text('CONTINUE'),
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
}

class _OnboardData {
  final String title;
  final String subtitle;
  final String botImage;

  const _OnboardData({required this.title, required this.subtitle, required this.botImage});
}
