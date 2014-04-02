ArmoredTruck
=============

ArmoredTruck is a web based file encryption tool that uses public key encryption to encrypt files for secure transfer or storage.

Setting Up
=============

ArmoredTruck is designed to be easily deployable using postgresql and unicorn web server in any environment,
but also integrates well with Heroku on the Cedar stack.

Using Heroku
==============
Follow the Heroku DevCenter setup for Rails 4:
https://devcenter.heroku.com/articles/getting-started-with-rails4

Use the custom buildpack to include the libsodium library:
heroku config:set BUILDPACK_URL=https://github.com/relotnek/heroku-buildpack-libsodium.git

Precompile Stylesheets and Assets using the following command:
RAILS_ENV=production bundle exec rake assets:precompile

Enable user-env-compile in Heroku:
heroku labs:enable user-env-compile

Generating Keys
===============

Generating keys is simple. Once you've created a user, you can generate your key pair by simply clicking the Generate button on the Edit Profile page. You will not be able to encrypt or decrypt files until you've completed this step

Encrypting Files
================
Once you're ready to encrypt a file you must create a Safe. A safe will be your tool for encrypting and decrypting files. Any safe can be used to encrypt or decrypt a file as long as your recipient exists in the system.
