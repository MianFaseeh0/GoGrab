import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const GoGrab());
}

class GoGrab extends StatelessWidget{
  const GoGrab({super.key});

  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('GoGrab'),
      ),
    );
  }
}