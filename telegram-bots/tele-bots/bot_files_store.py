import logging
from telegram.ext import Updater, CommandHandler, MessageHandler, Filters
import os

# Set up logging
logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

# Your bot's token
TOKEN = 'YOUR_TELEGRAM_BOT_TOKEN'

# Directory to save files
SAVE_DIRECTORY = '/path/to/your/directory'

# Command handler to start the bot
def start(update, context):
    update.message.reply_text("Send me any file, and I'll save it to my Ubuntu machine.")

# Handler for receiving files
def receive_file(update, context):
    file = update.message.document or update.message.video or update.message.audio or update.message.voice or update.message.video_note or update.message.sticker or update.message.photo or update.message.animation or update.message.video or update.message.video_note or update.message.voice or update.message.contact or update.message.location or update.message.venue or update.message.poll or update.message.dice or update.message.text
    file_name = os.path.join(SAVE_DIRECTORY, file.file_name)
    file.get_file().download(file_name)
    update.message.reply_text(f"File '{file.file_name}' saved successfully!")

def main():
    # Create the Updater and pass it your bot's token
    updater = Updater(TOKEN, use_context=True)

    # Get the dispatcher to register handlers
    dp = updater.dispatcher

    # Register command handlers
    dp.add_handler(CommandHandler("start", start))

    # Register a message handler for receiving files
    dp.add_handler(MessageHandler(Filters.document | Filters.video | Filters.audio | Filters.voice | Filters.video_note | Filters.sticker | Filters.photo | Filters.animation | Filters.video | Filters.voice | Filters.contact | Filters.location | Filters.venue | Filters.poll | Filters.dice | Filters.text, receive_file))

    # Start the Bot
    updater.start_polling()
    updater.idle()

if __name__ == '__main__':
    main()
