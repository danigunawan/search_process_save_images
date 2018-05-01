# README

This is a Ruby on Rails application, running Rails 5.0.7 and Ruby 2.3.1. A background job, running with ActiveJob and sucker_punch, is utilized to process newly uploaded images. Uploaded images are asynchronously processed, marked up, and saved.

First, ensure ImageMagick and Tesseract are installed locally. On a Mac, this can be done with:
	
	brew install imagemagick
	brew install tesseract


Run `bundle install`

Setup the database: `rake db:create db:migrate`

Run the test suite: `rspec`

Run the application: `rails s`