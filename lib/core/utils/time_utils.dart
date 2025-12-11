/// أدوات التعامل مع الوقت
abstract final class TimeUtils {
  /// تنسيق الثواني إلى دقائق:ثواني
  static String formatSeconds(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// تنسيق الثواني إلى دقائق للعرض
  static String formatToMinutes(int totalSeconds) {
    final minutes = (totalSeconds / 60).round();
    return '$minutes دقيقة';
  }

  /// التحقق مما إذا مر 24 ساعة
  static bool hasPassedHours(DateTime lastTime, int hours) {
    final now = DateTime.now();
    final difference = now.difference(lastTime);
    return difference.inHours >= hours;
  }

  /// حساب الوقت المتبقي حتى موعد معين
  static Duration getTimeUntil(DateTime targetTime) {
    final now = DateTime.now();
    if (now.isAfter(targetTime)) {
      return Duration.zero;
    }
    return targetTime.difference(now);
  }
}
