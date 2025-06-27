-- Create Bible Reading Progress Table
-- Run this in your Supabase Dashboard > SQL Editor

-- Create the table
CREATE TABLE IF NOT EXISTS bible_reading_progress (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  book_name TEXT NOT NULL,
  completed_chapters INTEGER[] DEFAULT '{}',
  last_read TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Ensure one record per user per book
  UNIQUE(user_id, book_name)
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_bible_reading_progress_user_id ON bible_reading_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_bible_reading_progress_book_name ON bible_reading_progress(book_name);

-- Enable Row Level Security
ALTER TABLE bible_reading_progress ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Users can view their own reading progress" ON bible_reading_progress
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own reading progress" ON bible_reading_progress
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own reading progress" ON bible_reading_progress
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own reading progress" ON bible_reading_progress
  FOR DELETE USING (auth.uid() = user_id);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_bible_reading_progress_updated_at 
  BEFORE UPDATE ON bible_reading_progress 
  FOR EACH ROW 
  EXECUTE FUNCTION update_updated_at_column();

-- Verify the table was created
SELECT 'Bible reading progress table created successfully!' as status; 