import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/service_locator.dart';

/// شاشة الإعدادات
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool soundEnabled;
  late bool musicEnabled;
  late bool vibrationEnabled;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      soundEnabled = gameRepository.isSoundEnabled;
      musicEnabled = gameRepository.isMusicEnabled;
      vibrationEnabled = gameRepository.isVibrationEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.paddingMD),
        children: [
          _SettingCard(
            icon: Icons.volume_up,
            title: 'المؤثرات الصوتية',
            value: soundEnabled,
            onChanged: (value) async {
              await gameRepository.setSoundEnabled(value);
              setState(() => soundEnabled = value);
            },
          ),
          const SizedBox(height: AppDimens.paddingMD),
          _SettingCard(
            icon: Icons.music_note,
            title: 'الموسيقى',
            value: musicEnabled,
            onChanged: (value) async {
              await gameRepository.setMusicEnabled(value);
              setState(() => musicEnabled = value);
            },
          ),
          const SizedBox(height: AppDimens.paddingMD),
          _SettingCard(
            icon: Icons.vibration,
            title: 'الاهتزاز',
            value: vibrationEnabled,
            onChanged: (value) async {
              await gameRepository.setVibrationEnabled(value);
              setState(() => vibrationEnabled = value);
            },
          ),
          const SizedBox(height: AppDimens.paddingLG),
          _ActionCard(
            icon: Icons.refresh,
            title: 'إعادة تعيين التقدم',
            subtitle: 'حذف جميع البيانات والبدء من جديد',
            color: Colors.red,
            onTap: _showResetConfirmation,
          ),
          const SizedBox(height: AppDimens.paddingMD),
          _ActionCard(
            icon: Icons.info,
            title: 'حول اللعبة',
            subtitle: 'معلومات عن التطبيق',
            color: Colors.blue,
            onTap: _showAboutDialog,
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ تحذير'),
        content: const Text(
          'هل أنت متأكد من رغبتك في حذف جميع البيانات؟\n'
          'سيتم فقدان كل التقدم والنقاط!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              await gameRepository.resetProgress();
              if (!context.mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إعادة التعيين بنجاح')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('تأكيد الحذف'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حول اللعبة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🎮 ${AppConstants.appTitle}'),
            const SizedBox(height: AppDimens.paddingSM),
            Text('الإصدار: ${AppConstants.appVersion}'),
            const SizedBox(height: AppDimens.paddingMD),
            const Text('لعبة ممتعة لتعلم الكلمات العربية وتحسين المفردات'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingMD),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.paddingMD),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.paddingMD),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(AppDimens.radiusMD),
            ),
            child: Icon(icon, color: Colors.deepPurple),
          ),
          const SizedBox(width: AppDimens.paddingMD),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: Colors.deepPurple.withValues(alpha: 0.5),
            activeThumbColor: Colors.deepPurple,
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.paddingMD),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.paddingMD),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.paddingMD),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.paddingMD),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: AppDimens.paddingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
