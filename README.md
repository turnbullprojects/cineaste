# Cineaste

Cineaste is a gem that takes a string and turns it into a video output. The gem searches a given S3 bucket for videos matching each word, then concatenates them together. If the videos are not found, the gem creates videos using a template file video and text-to-speech. 

Cineaste Server is a small Sinatra application that uses the Gem. 


## Usage

```ruby
@dictionary = "standard" 
@input = "welcome to crumbles" #this will be sanitized
@voice = "male" # male or female (determines which TTS service to use)

phrase = Cineaste::Phrase.new(@dictionary,@input,@voice)
phrase.get_video #will find or create a video on AWS and return the AWS URL as a string
```

## File Structure

Currently the gem is hardcoded to use the 'crumbles-2015' bucket. 

Videos are classified as "defined" or "generated." Generated videos are videos that have been created using a template video and MP3.

To add a new dictionary, simply create the following folder in S3:
`$S3_BUCKET/rresources/:video/dictionaries/:dictionary/defined/`
and add your videos there. 

The following files will be generated during use:

```
$S3_BUCKET/resources/:video/dictionaries/:dictionary/generated/undefined_word.mp4
$S3_BUCKET/resources/:video/dictionaries/:dictionary/phrases/base64_hash_of_phrase.mp4
$S3_BUCKET/esources/:audio/voice/:voice/tts_of_a_word.mp3
```

Files are stored locally in the tmp/ folder for use with FFMPEG. These files are *not* automatically deleted at this time. 

A simple but functional server can be found in `cineaste-server/`. See the `README.md` there for more information.

## Requirements

- FFMPEG
- AWS key and secret set for aws-cli (or in `s3_client.rb`)


## Next Steps:

- Tests
- Extract S3 creds, file tree structure, and template video into config file
- Ensure tmp/ folder is periodically emptied

## Longer Term:

- Account for multi-word phrases (eg. "ice cream")
- Include ability to censor certain words from a list
- Check for homonyms and mispellings as well as exact matches
- Replace special chars used for letters ($ -> s)
- Compress common mispellings (eg. "loooooolll" ->  "lol"). Check analytics for full list
- Ignore gibberish as best as possible (can we drop something like "(&*UHEJF" ?) 

The `icebox/` folder has a few word lists to help with the above.

