# Redmine Journal Notes History

This plugin provides a issue's notes history management. 

## Features

- Save previous issue's note in database.
- Show issue's note history.
- Show each issue's note diff.

## Install

1. Download plugin
   ```sh
   git clone https://github.com/9506hqwy/redmine_journal_notes_history
   ```
2. Install dependency libraries
   ```sh
   bundle install --without development test 
   ```
3. Install plugin
   ```sh
   bundle exec rake redmine:plugins NAME=redmine_journal_notes_history RAILS_ENV=production
   ```
4. Start Redmine

## Tested Environment

* Redmine (Docker Image)
  * 3.4
  * 4.0
  * 4.1
  * 4.2
  * 5.0
* Database
  * SQLite
  * MySQL5.7
  * PostgreSQL12

## References

- [#12388 diffs for editions of issue/notes entries](https://www.redmine.org/issues/12388)
