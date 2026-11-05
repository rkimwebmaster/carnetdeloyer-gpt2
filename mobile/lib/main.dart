import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/config/environnement.dart';
import 'core/l10n/l10n.dart';
import 'core/navigation/routeur.dart';
import 'core/session/session.dart';
import 'core/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr');
  runApp(const ProviderScope(child: AppCdl()));
}

class AppCdl extends ConsumerStatefulWidget {
  const AppCdl({super.key});

  @override
  ConsumerState<AppCdl> createState() => _AppCdlState();
}

class _AppCdlState extends ConsumerState<AppCdl> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// R-141 : l'app se verrouille quand elle passe en arrière-plan.
  @override
  void didChangeAppLifecycleState(AppLifecycleState etat) {
    if (etat == AppLifecycleState.paused) ref.read(sessionProvider.notifier).verrouiller();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: Config.nomApp,
      debugShowCheckedModeBanner: Config.environnement != Environnement.prod,
      theme: ThemeCdl.clair(),
      darkTheme: ThemeCdl.sombre(),
      routerConfig: ref.watch(routeurProvider),
      // R-89, R-90 : français en v0.1, structure prête pour l'anglais et le swahili.
      locale: const Locale('fr'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
