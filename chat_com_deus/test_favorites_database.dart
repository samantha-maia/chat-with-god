import 'package:supabase_flutter/supabase_flutter.dart';

// Test script to verify favorites database functionality
// Run this in your Supabase SQL editor to check the database structure

/*
-- Check if is_favorite column exists in conversations table
SELECT column_name, data_type, is_nullable, column_default 
FROM information_schema.columns 
WHERE table_name = 'conversations' AND column_name = 'is_favorite';

-- Check if is_favorite column exists in messages table
SELECT column_name, data_type, is_nullable, column_default 
FROM information_schema.columns 
WHERE table_name = 'messages' AND column_name = 'is_favorite';

-- Check if personal_note column exists in messages table
SELECT column_name, data_type, is_nullable, column_default 
FROM information_schema.columns 
WHERE table_name = 'messages' AND column_name = 'personal_note';

-- View sample data to verify structure
SELECT id, title, is_favorite, created_at, updated_at 
FROM conversations 
LIMIT 5;

-- View sample messages with favorites and notes
SELECT id, content, message_type, is_favorite, personal_note, created_at 
FROM messages 
LIMIT 5;

-- Count favorite conversations
SELECT COUNT(*) as favorite_conversations 
FROM conversations 
WHERE is_favorite = true;

-- Count favorite messages
SELECT COUNT(*) as favorite_messages 
FROM messages 
WHERE is_favorite = true;

-- Count messages with personal notes
SELECT COUNT(*) as messages_with_notes 
FROM messages 
WHERE personal_note IS NOT NULL AND personal_note != '';
*/ 