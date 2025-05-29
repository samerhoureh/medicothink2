import 'package:flutter/material.dart';

const Color kTeal = Color(0xFF20A9C3);
const Color kIndicatorGrey = Color(0xFFD9D9D9); 

class ChatDrawer extends StatefulWidget {
  const ChatDrawer({super.key});

  @override
  State<ChatDrawer> createState() => _ChatDrawerState();
}


class _ChatDrawerState extends State<ChatDrawer> {
  String _activeSection = 'Previous 7 Days';
  int _activeIndex = 1;

  void _onSelect(String section, int index) {
    setState(() {
      _activeSection = section;
      _activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 270,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            Center(
              child: Image.asset(
                'assets/images/splash/medico_logo.jpg',
                height: 200,
                width: 200,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(fontSize: 13),
                  prefixIcon: const Icon(Icons.search, size: 18),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Chat Summary',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _DrawerSection(
                    label: 'Yesterday',
                    items: const [
                      'Hi, thanks for accompanying…',
                      'Need headache medicine',
                      'Diet information',
                    ],
                    onSelect: (i) => _onSelect('Yesterday', i),           
                    activeIndex: _activeSection == 'Yesterday' ? _activeIndex : null,
                  ),
                  _DrawerSection(
                    label: 'Previous 7 Days',
                    labelColor: Colors.blue,
                    items: const [
                      'Importance of diet',
                      'What is this medicine?',
                      'Headache treatment',
                      'Importance of exercise',
                    ],
                    onSelect: (i) => _onSelect('Previous 7 Days', i),    
                    activeIndex: _activeSection == 'Previous 7 Days' ? _activeIndex : null, 
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

class _DrawerSection extends StatelessWidget {
  final String label;
  final List<String> items;
  final Color? labelColor;
  final int? activeIndex;          
  final ValueChanged<int>? onSelect;

  const _DrawerSection({
    required this.label,
    required this.items,
    this.labelColor,
    this.activeIndex,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor ?? Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        for (int i = 0; i < items.length; i++)
          InkWell(
            onTap: () => onSelect?.call(i),          
            child: Container(
              width: double.infinity,                
              decoration: BoxDecoration(
                color: (activeIndex == i) ? kIndicatorGrey : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Text(
                items[i],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: (activeIndex == i) ? FontWeight.w600 : null,
                ),
              ),
            ),
          ),

        const SizedBox(height: 20),
      ],
    );
  }
}
