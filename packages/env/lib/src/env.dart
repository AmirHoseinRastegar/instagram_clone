enum Env {
  supabaseUrl('SUPABASE_URL'),
  powerSyncUrl('POWERSYNC_URL'),
 
  supabaseAnonKey('SUPABASE_ANON_KEY');

  const Env(this.value);

  final String value;
}