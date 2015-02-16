# Cineaste

Cineaste is a gem that takes a string and turns it into a video output. The gem searches a given S3 bucket for videos matching each word, then concatenates them together. If the videos are not found, the gem creates videos using a template file video and text-to-speech. 

## Usage

Gemfile: 
`require 'cineaste', git: 'https://github.com/thegempath/thegem.git'`

Make it happen:

`@dictionary = "standard" 
@input = "welcome to crumbles" #this will be sanitized
@voice = "male" # male or female (determines which TTS service to use)

phrase = Cineaste::Phrase.new(@dictionary,@input,@voice)
phrase.get_video #will find or create a video on AWS and return the AWS URL as a string`

## File Structure

Currently the gem is hardcoded to use the 'crumbles-2015' bucket. 

Videos are classified as "defined" or "generated." Generated videos are videos that have been created using a template video and MP3.

To add a new dictionary, simply create the following folder in S3:
`/resources/:video/dictionaries/:dictionary/defined/`
and add your videos there. 

The following files will be generated during use:
/resources/:video/dictionaries/:dictionary/generated/undefined_word.mp4
/resources/:video/dictionaries/:dictionary/phrases/base64_hash_of_phrase.mp4
/resources/:audio/voice/:voice/tts_of_a_word.mp3

Files are stored locally in the tmp/ folder for use with FFMPEG

## To Do:
- Create config file that takes S3 creds, file tree structure, and template video 
- TESTS
- Automatically clear tmp/ folder
