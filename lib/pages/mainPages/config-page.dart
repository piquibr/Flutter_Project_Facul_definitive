import 'package:flutter/material.dart';
import 'package:flutter_project_todo_list/login-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/help-page.dart';
import 'package:flutter_project_todo_list/pages/mainPages/inicialMain-page.dart';
import 'package:flutter_project_todo_list/pages/recoveryPassword-page.dart';
import 'package:flutter_project_todo_list/pages/updatePassword-page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Para persistência de estado
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Config extends StatelessWidget {
  final String userId;

  const Config({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfigScreen(userId: userId);
  }
}

class ConfigScreen extends StatefulWidget {
  final String userId;

  const ConfigScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  late String _userId;
  bool _isDarkMode = false;
  bool _notificationsEnabled = true; // Estado inicial para notificações

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _loadPreferences();
  }

  /// Carrega as preferências de notificações e modo escuro do usuário.
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
    });
  }

  /// Salva as preferências de notificações e modo escuro.
  Future<void> _savePreferences(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  /// Ativa ou desativa notificações.
  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });

    if (_notificationsEnabled) {
      _enableNotifications();
    } else {
      _disableNotifications();
    }

    _savePreferences('notifications_enabled', _notificationsEnabled);
  }

  /// Ativa notificações.
  Future<void> _enableNotifications() async {
    // Exemplo de configuração de notificação básica ao ativar
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel_id',
      'Default Notifications',
      channelDescription: 'Canal padrão para notificações',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Notificações Ativadas',
      'Você ativou as notificações.',
      platformDetails,
    );
  }

  /// Desativa notificações.
  Future<void> _disableNotifications() async {
    // Remove notificações pendentes ao desativar
    await flutterLocalNotificationsPlugin.cancelAll();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notificações desativadas.')),
    );
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
    _savePreferences('dark_mode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Alterar senha'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdatePassword(userId: _userId),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notificações'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
              activeTrackColor: Colors.orange,
              activeColor: Colors.white,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Ajuda'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpPage(title: ''),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}