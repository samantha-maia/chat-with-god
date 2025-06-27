class SupabaseConfig {
  // Replace these with your actual Supabase credentials
  static const String supabaseUrl = 'https://ciizsqypsscoeohrcpnv.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNpaXpzcXlwc3Njb2VvaHJjcG52Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA5NzM3NjQsImV4cCI6MjA2NjU0OTc2NH0.eGBvhiRYNLD-O6GzQPEI_dvPCfrvrg42KIF24XAY4OM';
  
  // Table names
  static const String usersTable = 'users';
  static const String conversationsTable = 'conversations';
  static const String messagesTable = 'messages';
  static const String bibleVersesTable = 'bible_verses';
  static const String readingPlansTable = 'reading_plans';
  static const String userReadingPlansTable = 'user_reading_plans';
  static const String readingPlanVersesTable = 'reading_plan_verses';
  static const String subscriptionEventsTable = 'subscription_events';
  static const String userPreferencesTable = 'user_preferences';
  static const String bibleReadingProgressTable = 'bible_reading_progress';
} 