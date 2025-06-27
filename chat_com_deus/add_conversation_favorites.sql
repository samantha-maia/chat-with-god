-- Add is_favorite column to conversations table
ALTER TABLE conversations 
ADD COLUMN is_favorite BOOLEAN DEFAULT FALSE;

-- Create index for better performance when querying favorite conversations
CREATE INDEX idx_conversations_is_favorite ON conversations(is_favorite);

-- Update existing conversations to have is_favorite = false
UPDATE conversations SET is_favorite = FALSE WHERE is_favorite IS NULL;

-- Add comment to the column
COMMENT ON COLUMN conversations.is_favorite IS 'Whether this conversation is marked as favorite by the user'; 