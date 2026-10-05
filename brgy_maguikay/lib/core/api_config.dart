/// Central place for the API's base URL.
///
/// - Android emulator -> host machine's localhost is 10.0.2.2
/// - iOS simulator    -> localhost works directly
/// - Physical device   -> use your computer's LAN IP, e.g. http://192.168.1.23:5231
/// - Chrome/web         -> localhost works directly
///
/// Swap this value for whichever device you're running on. If you run the
/// API with `dotnet run` locally, the port is the one from launchSettings.json
/// (5231 for http, 7263 for https).
class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:5231';
}
