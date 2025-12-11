import '../data/datasources/local/levels_local_datasource.dart';
import '../data/datasources/local/progress_local_datasource.dart';
import '../data/repositories/game_repository.dart';

/// محدد الخدمات - نمط Service Locator
/// يوفر نقطة وصول مركزية لجميع الخدمات والمستودعات
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  static ServiceLocator get instance => _instance;

  // الخدمات المسجلة
  final Map<Type, dynamic> _services = {};

  // هل تم التهيئة
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// تهيئة جميع الخدمات
  Future<void> initialize() async {
    if (_isInitialized) return;

    // تهيئة مصادر البيانات المحلية
    final progressDataSource = await HiveInitializer.initialize();
    final levelsDataSource = LevelsLocalDataSourceImpl();

    // تسجيل مصادر البيانات
    register<ProgressLocalDataSource>(progressDataSource);
    register<LevelsLocalDataSource>(levelsDataSource);

    // تهيئة وتسجيل المستودعات
    final gameRepository = GameRepositoryImpl(
      levelsDataSource: levelsDataSource,
      progressDataSource: progressDataSource,
    );
    register<GameRepository>(gameRepository);

    _isInitialized = true;
  }

  /// تسجيل خدمة
  void register<T>(T service) {
    _services[T] = service;
  }

  /// الحصول على خدمة
  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception('الخدمة ${T.toString()} غير مسجلة. تأكد من استدعاء initialize() أولاً.');
    }
    return service as T;
  }

  /// التحقق من تسجيل خدمة
  bool isRegistered<T>() {
    return _services.containsKey(T);
  }

  /// إلغاء تسجيل خدمة
  void unregister<T>() {
    _services.remove(T);
  }

  /// تنظيف جميع الخدمات
  Future<void> dispose() async {
    if (isRegistered<GameRepository>()) {
      await get<GameRepository>().close();
    }
    _services.clear();
    _isInitialized = false;
  }

  /// إعادة تعيين (للاختبارات)
  void reset() {
    _services.clear();
    _isInitialized = false;
  }
}

/// اختصارات للوصول السريع
ServiceLocator get sl => ServiceLocator.instance;
GameRepository get gameRepository => sl.get<GameRepository>();
