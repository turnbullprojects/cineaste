# Cineaste

Gemfile: 
`require 'cineaste', git: 'https://github.com/thegempath/thegem.git'`

Make it happen:
`@dictionary = "standard"` 
`@input = "welcome to crumbles"` (this will be sanitized)
`@voice = "male"` (male or female)
`phrase = Cineaste::Phrase.new(@dictionary,@input,@voice)`
`phrase.get_video` will find or create a video on AWS and return the AWS URL as a string

# To Do:
Move S3 info into config file
Add MP4 encoding

