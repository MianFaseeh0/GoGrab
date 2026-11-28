import 'dart:ui' show PointerDeviceKind;
import 'package:material_ui/material_ui.dart';
import 'core/state.dart';
import 'core/svg_data.dart' hide kK, kR, kC, kG;
import 'core/theme.dart';
import 'core/ui.dart';
import 'screens/auth.dart';
import 'screens/crew.dart';
import 'screens/home.dart';
import 'screens/join.dart';
import 'screens/runform.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initIcons(); 
  initCats();
  initData();
  runApp(const GoGrabApp());
}

class _Scroll extends MaterialScrollBehavior {
  const _Scroll();
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}

class GoGrabApp extends StatelessWidget {
  const GoGrabApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'GoGrab',
      debugShowCheckedModeBanner: false,
      navigatorKey: navKey,
      scrollBehavior: const _Scroll(),
      theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: kC,
          splashFactory: NoSplash.splashFactory,
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: kK, selectionColor: rgba(129, 0, 0, .25), selectionHandleColor: kR)),
      // Confetti and toast sit above the navigator, so they also show over sheets.
      builder: (ctx, child) => Stack(fit: StackFit.expand, children: [
            child!,
            ConfettiLayer(),
            const ToastHost(),
          ]),
      home: const Shell());
}

class Shell extends StatelessWidget {
  const Shell({super.key});

  Widget _screen(String r) => switch (r) {
        'login' => const LoginScreen(),
        'face' => const FaceScreen(),
        'hub' => const HubScreen(),
        'name' => const NameScreen(),
        'inv' => const InviteScreen(),
        'jn' => const JoinScreen(),
        'home' => const HomeScreen(),
        'crew' => const CrewScreen(),
        'edit' => const EditScreen(),
        _ => const LoginScreen(),
      };

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: kC,
      body: DefaultTextStyle(
          style: tx(16, color: kK),
          child: Center(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: DotBg(
                      child: ValueListenableBuilder<String>(
                          valueListenable: route,
                          builder: (c, r, _) => AnimatedSwitcher(
                              duration: const Duration(milliseconds: 320),
                              transitionBuilder: (w, a) => FadeTransition(
                                  opacity: a,
                                  child: SlideTransition(
                                      position: Tween<Offset>(
                                              begin: const Offset(0, .03), end: Offset.zero)
                                          .animate(a),
                                      child: w)),
                              child: KeyedSubtree(key: ValueKey(r), child: _screen(r)))))))));
}