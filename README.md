# GitDayOne

A gem for generating reports on git projects and formatting them for the [Day One](http://dayoneapp.com/)
application.


## Installation

Add this line to your application's Gemfile:

    gem 'git_day_one'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git_day_one

## Usage

1. Install Day One [command line
   tools](https://dayone.zendesk.com/hc/en-us/articles/200258954-Day-One-Tools)
2. Copy the example file `.git_day_one.yml.example` to `~/.git_day_one.yml`
3. Change the author name and add projects to projects hash
4. Run the script `dit_day_one` in the bin directory to test
5. When ready to add the report to day one run `./bin/git_day_one | dayone new`
