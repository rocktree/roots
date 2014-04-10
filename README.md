Roots
=======================

Roots is a starting point for Ruby on Rails applications. It helps you get rid
of all the nonsensical monotony you have to undergo at the beginning of every
project. Plus, it adds a few features and functionality to help streamline your
development and keep you focusing on business logic.

Getting Started
-----------------------

### Setup

First, grab a copy of the repo for yourself.

```
$ git clone git@github.com:seancdavis/roots.git your_project_name
```

Change the remote origin to push to your new project location.

```
$ git remote set-url origin your_new_url
$ git push origin master
```

Then, let's go into the project and install our default gems.

```
$ cd your_project_name
$ bundle install --local
```

Then we can rename the app.

```
$ bundle exec rake rename:app[new_name]
```

> If you're using zsh, you may need to escape the brackets -- `\[new_name\]`.

### Database

Next, choose the database you'd like to use. We have a starting point for both
MySQL and PostgreSQL.

#### Copy File

Choose the appropriate database you'd like to use, then copy the configuration
file to `config/database.yml`. For example, if you want to use postgres, you
would copy `config/database.pg.yml` to `config/database.yml`.

Change this file with the appropriate credentials for your development
environment.

> We aren't tracking this file by default (for security reasons). If you need to
> track it, remove it from `.gitignore`.
>
> Note, though, it is because we aren't tracking this file that you should
> **copy the configuration instead of renaming it**, as that would remove it
> from git, which removes it from the repo for future collaborators.

#### Update Gemfile

If you've chosen postgres, you'll want to update the `Gemfile` -- remove `gem
'mysql'` and uncomment `gem 'pg'`. Then update your bundle:

```
$ bundle install
$ bundle clean
```

#### Setup Database

Now you can create, migrate and seed the database.

```
$ bundle exec rake db:setup
```

### Start It Up!

Now you should be able to start up your Rails server and get busy development.

```
$ bundle exec rails s
```
