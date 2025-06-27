#!/bin/bash

# OpenAI Configuration Setup Script
# This script helps you set up OpenAI with your Supabase project

echo "🚀 Setting up OpenAI configuration for Chat with God app..."

# Check if Supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI is not installed. Please install it first:"
    echo "   https://supabase.com/docs/reference/cli/install"
    exit 1
fi

# Check if we're in a Supabase project
if [ ! -f "supabase/config.toml" ]; then
    echo "❌ Not in a Supabase project directory. Please run this script from your project root."
    exit 1
fi

# Prompt for OpenAI API key
echo "📝 Please enter your OpenAI API key:"
read -s OPENAI_API_KEY

if [ -z "$OPENAI_API_KEY" ]; then
    echo "❌ OpenAI API key is required. Please get one from:"
    echo "   https://platform.openai.com/api-keys"
    exit 1
fi

# Check if we're in local development or production
echo "🌍 Are you setting up for local development or production?"
echo "1) Local development"
echo "2) Production"
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        echo "🔧 Setting up for local development..."
        
        # Start Supabase locally
        echo "Starting Supabase locally..."
        supabase start
        
        # Set the OpenAI API key
        echo "Setting OpenAI API key..."
        supabase secrets set OPENAI_API_KEY="$OPENAI_API_KEY"
        
        # Deploy the function
        echo "Deploying chatgpt function..."
        supabase functions deploy chatgpt
        
        echo "✅ Local setup complete!"
        echo "🎯 You can now test your app locally."
        ;;
    2)
        echo "🚀 Setting up for production..."
        
        # Prompt for project reference
        echo "📝 Please enter your Supabase project reference:"
        read PROJECT_REF
        
        if [ -z "$PROJECT_REF" ]; then
            echo "❌ Project reference is required."
            exit 1
        fi
        
        # Set the OpenAI API key
        echo "Setting OpenAI API key..."
        supabase secrets set --project-ref "$PROJECT_REF" OPENAI_API_KEY="$OPENAI_API_KEY"
        
        # Deploy the function
        echo "Deploying chatgpt function..."
        supabase functions deploy chatgpt --project-ref "$PROJECT_REF"
        
        echo "✅ Production setup complete!"
        echo "🎯 Your app is now ready for production."
        ;;
    *)
        echo "❌ Invalid choice. Please run the script again."
        exit 1
        ;;
esac

echo ""
echo "🎉 Setup complete! Your OpenAI integration is now configured."
echo ""
echo "📚 Next steps:"
echo "1. Test the chat functionality in your Flutter app"
echo "2. Monitor usage in your OpenAI dashboard"
echo "3. Check the setup guide at setup_openai.md for more details"
echo ""
echo "🔧 If you need to troubleshoot, check the function logs:"
if [ "$choice" = "1" ]; then
    echo "   supabase functions logs chatgpt"
else
    echo "   supabase functions logs chatgpt --project-ref $PROJECT_REF"
fi 