# OpenAI Configuration Setup Guide

## Prerequisites
1. An OpenAI API key (get one from https://platform.openai.com/api-keys)
2. Supabase CLI installed and configured
3. Your Supabase project running

## Step 1: Set OpenAI API Key in Supabase

### For Local Development:
```bash
# Start your local Supabase instance
supabase start

# Set your OpenAI API key
supabase secrets set OPENAI_API_KEY=your_openai_api_key_here
```

### For Production:
```bash
# Set your OpenAI API key in production
supabase secrets set --project-ref your_project_ref OPENAI_API_KEY=your_openai_api_key_here
```

## Step 2: Deploy the Edge Function

```bash
# Deploy the chatgpt function
supabase functions deploy chatgpt
```

## Step 3: Test the Function

You can test the function locally or in production:

### Local Testing:
```bash
curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/chatgpt' \
  --header 'Authorization: Bearer your_jwt_token' \
  --header 'Content-Type: application/json' \
  --data '{"message":"How can I find peace in difficult times?","userId":"your_user_id"}'
```

### Production Testing:
```bash
curl -i --location --request POST 'https://your_project_ref.supabase.co/functions/v1/chatgpt' \
  --header 'Authorization: Bearer your_jwt_token' \
  --header 'Content-Type: application/json' \
  --data '{"message":"How can I find peace in difficult times?","userId":"your_user_id"}'
```

## Step 4: Environment Variables

Make sure these environment variables are set in your Supabase project:
- `OPENAI_API_KEY`: Your OpenAI API key
- `SUPABASE_URL`: Your Supabase project URL (automatically set)
- `SUPABASE_SERVICE_ROLE_KEY`: Your Supabase service role key (automatically set)

## Step 5: Update Your Flutter App

The Flutter app has been updated to use the real OpenAI API. The chat provider now:
1. Sends messages to the Supabase Edge Function
2. Receives Bible-based responses from OpenAI
3. Saves conversations to the database
4. Handles errors gracefully

## Troubleshooting

### Common Issues:

1. **"OpenAI configuration error"**: Make sure your OpenAI API key is set correctly
2. **"Invalid or expired token"**: Ensure the user is properly authenticated
3. **"User ID mismatch"**: Verify the user ID in the request matches the authenticated user

### Check Function Logs:
```bash
# Local logs
supabase functions logs chatgpt

# Production logs
supabase functions logs chatgpt --project-ref your_project_ref
```

## Security Notes

- The Edge Function validates JWT tokens before processing requests
- User ID is verified against the authenticated user
- OpenAI API key is stored securely in Supabase secrets
- CORS is properly configured for web access

## Next Steps

1. Test the chat functionality in your Flutter app
2. Monitor usage and costs in your OpenAI dashboard
3. Consider implementing rate limiting if needed
4. Add more sophisticated conversation management features 