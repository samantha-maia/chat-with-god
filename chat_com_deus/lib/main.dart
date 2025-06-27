import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'shared/providers/auth_provider.dart';
import 'shared/providers/theme_provider.dart';
import 'features/auth/auth_screen.dart';
import 'features/bible/home_screen.dart';
import 'shared/widgets/main_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final user = ref.watch(authNotifierProvider);
    
    return MaterialApp(
      title: 'Chat with God',
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: user == null ? const AuthScreen() : const MainScaffold(child: HomeScreen()),
      debugShowCheckedModeBanner: false,
    );
  }
}
