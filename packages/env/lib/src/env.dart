/// Environment variables for the application
enum Env {
  /// Supabase project URL
  supabaseUrl('SUPABASE_URL'),

  /// PowerSync server URL
  powerSyncUrl('POWERSYNC_URL'),

  /// Supabase anonymous key
  supabaseAnonKey('SUPABASE_ANON_KEY'),

  /// iOS OAuth client ID
  iOSClientId('IOS_CLIENT_ID'),

  /// Web OAuth client ID
  webClientId('WEB_CLIENT_ID');

  const Env(this.value);

  // ignore: public_member_api_docs
  final String value;
}
