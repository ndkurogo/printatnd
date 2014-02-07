Print@ND
========
Print@ND allows sending documents to the University of Notre Dame's printing
system, bound to a NetID.

Setup
-----
* You will need MySQL and Redis to be installed before you can start working
  with the server.
* Copy `config/database.yml.template` to `config/database.yml` and modify the
  contents to match your MySQL setup.
* Print@ND makes use of the [Ink File Picker][fp]. In order for this to work,
  the API key in `config/initializers/filepicker.rb` must be modified, and a
  matching "app secret" must be in an environment variable called
  `FILEPICKER_SECRET`.
* In the [Ink File Picker][fp] developer panel--specifically, in the "Web
  Dialog" section under "Look and Feel"--change the option "URL for Desktop
  CSS" to "https://_App Address Here_/assets/fp\_dialog\_desktop.css" and "URL
  for Mobile CSS" to "https://_App Address Here_/assets/fp\_dialog\_mobile.css".
  This will implement a few functional and cosmetic changes in the filepicker
  dialog.
* Be sure to also include a random string in the `SECRET_TOKEN` environment
  variable, to ensure Rails' secure cookie is actually secure.


Running
-------
To run this locally, in development mode, with the default Rails server:

    $ bundle install
    $ rails server
  
Then just point your browser at `http://localhost:3000`.

For a production environment, Phusion Passenger is known to work. First
precompile the site assets (a one-time task):

    $ rake assets:precompile

When using Passenger with Apache, `FILEPICKER_SECRET` and `SECRET_TOKEN` can be
defined directly in a VirtualHost directive, e.g.:

    SetEnv FILEPICKER_SECRET ZYXWVUTSRQPONMLKJIHGFEDCBA
    SetEnv SECRET_TOKEN 0123456789abcdef0123456789abcdef

However, the Resque workers (which process the print jobs in the background)
will not be automatically started this way, so they must be started separately:

    $ export FILEPICKER_SECRET=ABCDEFGHIJKLMNOPQRSTUVWXYZ
    $ export RAILS_ENV=production
    $ script/resque start
  
Credits
-------
* [Sam Aarons](http://samaarons.com) -- Wrote original Print@CU system for
  Columbia University's NINJa printing system
* Kevin Riehm -- Modified Print@CU to work with Notre Dame's printing system
  
External Links
--------------
* [Print@CU](https://printatcu.com)

[fp]: https://filepicker.io

