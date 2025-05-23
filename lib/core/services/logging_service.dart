import 'package:logger/logger.dart';

/// Centralized logging service for the application
class LoggingService {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  /// Log a debug message
  static void d(String message, {dynamic error, StackTrace? stackTrace}) {
    if (error != null) {
      _logger.d('$message', error: error, stackTrace: stackTrace);
    } else {
      _logger.d(message);
    }
  }

  /// Log an info message
  static void i(String message, {dynamic error, StackTrace? stackTrace}) {
    if (error != null) {
      _logger.i('$message', error: error, stackTrace: stackTrace);
    } else {
      _logger.i(message);
    }
  }

  /// Log a warning message
  static void w(String message, {dynamic error, StackTrace? stackTrace}) {
    if (error != null) {
      _logger.w('$message', error: error, stackTrace: stackTrace);
    } else {
      _logger.w(message);
    }
  }

  /// Log an error message
  static void e(String message, {dynamic error, StackTrace? stackTrace}) {
    if (error != null) {
      _logger.e('$message', error: error, stackTrace: stackTrace);
    } else {
      _logger.e(message);
    }
  }

  /// Log a verbose message
  static void v(String message, {dynamic error, StackTrace? stackTrace}) {
    if (error != null) {
      _logger.v('$message', error: error, stackTrace: stackTrace);
    } else {
      _logger.v(message);
    }
  }

  /// Log a wtf (what a terrible failure) message
  static void wtf(String message, {dynamic error, StackTrace? stackTrace}) {
    if (error != null) {
      _logger.wtf('$message', error: error, stackTrace: stackTrace);
    } else {
      _logger.wtf(message);
    }
  }
}
