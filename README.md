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

Seeding Database
-----------------------

We have a few handy tasks to help you seed your database. Since the models you
create will likely differ from project-to-project, we've taken the route of
using seeds versus rake tasks. However, that can be a much faster way to
approach filling a database if you just need test data.

Otherwise, once you have some models you can create the seed files by running
this rake task.

```
$ bundle exec rake db:seed:create_files
```

This looks to your existing models and creates a CSV file for each model in
`db/csv/`. You may remove columns as necessary and fill up those files with test
data. The next time you seed your database, these files will be read and added
to the database.

Once your database is created, the best way to go about ensuring your seeds are
all in there and you haven't added something twice is to reset the database.

```
$ bundle exec rake db:reset
```

This will attempt to drop, create, migrate and seed your database.

### Editing Columns

Column headings can be edited as you wish, but they **must be valid attributes
within the model**.

For example, the `User` has many attributes we don't care about when we create a
user. Plus, we need the attributes `password` and `password_confirmation` to
successfully create a user. Therefore, we can edit these columns if necessary.
Take a look at the default `db/seeds/user.csv` file as an example.

### Overwriting ID

You don't have to, but you may overwrite the object `id` attribute, so long as
it is valid.

### Uploading Files

We've made uploading test files nice and easy, too. Add `:file` to the CSV
heading, then add the filename (with extension) of the file to upload in the
appropriate row. And last, drop the file in `lib/assets/seeds`, since that's
where we look for an upload (to keep your CSV files clean).

So, if your file attribute is `image`, your CSV heading would be `image:file`,
then you could add `image.jpg` to the right CSV row, and add the file to
`lib/assets/seeds/image.jpg`.

> This is only tested using CarrierWave. CarrierWave is not yet a part of this
> repo. But it is a great gem and very easy to work with. [Check it
> out.](https://github.com/carrierwaveuploader/carrierwave)
