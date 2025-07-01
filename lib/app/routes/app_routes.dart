part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const MAP = _Paths.MAP;
  static const DELIVERIES = _Paths.DELIVERIES;
  static const SETTINGS = _Paths.SETTINGS;
}

abstract class _Paths {
  _Paths._();

  static const HOME = '/home';
  static const MAP = '/map';
  static const DELIVERIES = '/deliveries';
  static const SETTINGS = '/settings';
}
