# Redmine Journal Notes History

This plugin provides a issue's note history management.

## Features

- Save previous issue's note in database.
- Show issue's note history.
- Show each issue's note diff.
- Show update activity of non-private note.

## Installation

1. Download plugin in Redmine plugin directory.
   ```sh
   git clone https://github.com/9506hqwy/redmine_journal_notes_history.git
   ```
2. Install dependency libraries in Redmine directory.
   ```sh
   bundle install --without development test
   ```
3. Install plugin in Redmine directory.
   ```sh
   bundle exec rake redmine:plugins:migrate NAME=redmine_journal_notes_history RAILS_ENV=production
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
  * MySQL 5.7
  * PostgreSQL 12

## References

- [#12388 diffs for editions of issue/notes entries](https://www.redmine.org/issues/12388)
- [#31505 Mark edited journal notes as "Edited"](https://www.redmine.org/issues/31505)
