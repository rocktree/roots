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

> This is only tested using
> [CarrierWave](https://github.com/carrierwaveuploader/carrierwave).
> CarrierWave is not yet a part of this repo. But it is a great gem and very
> easy to work with.

Users
-----------------------

We're using [Devise](https://github.com/plataformatec/devise) to manage our
users and user authentication. Devise is a great gem and it's nice and easy to
work with.

Once you're set up and running, the `User` model is already created and working,
along with support for access to the admin namespace.

### Roles

By default there are only two roles, and they are designated by the `is_admin`
boolean on the `User` model. By default, only those users with `is_admin` set to
`true` have access to the CMS, or `admin` namespace (i.e. anything that inherits
from the `AdminController`). There is more about this below.

Settings
-----------------------

Sometimes it's necessary (or nice) to have global settings accessible throughout
your project. While you can use
[locales](http://guides.rubyonrails.org/i18n.html) to take care of some of those
options, we've provided an alternative option with Roots.

By default, you have a file in `config/settings.yml`. This is where you should
place any global constants. This file is read on server start and placed into a
`SETTINGS` constant hash, by reading your current environment.

For example, if you look at the default file, you see this:

```
development: &default
  say_hello: "Hello World!"

test: &test
  <<: *default

production: &production
  <<: *default
```

If you start up the server, the output of `SETTINGS['say_hello']` would be
`'Hello World!'`.

By default, the `test` and `production` environments inherit from `development`,
but you could change any values as needed. Just add them under the `<<:
*default` line.

> **Don't forget to restart your server when adding new values.**

### Sensitive Data

In some cases, you may want a feature like this, but you don't want to add the
values to your repo. We've provided a similar approach to private settings.

You'll see a file at `config/settings_private.sample.yml`. You can rename or
copy this file to `config/settings_private.yml`. Then, when you restart your
server, you'll have the values within that file available through a global
`PRIVATE` constant. And the `settings_private.yml` file is ignored by git.

Content Management System (Admin)
-----------------------

Roots comes with a base framework to help you easily build out a content
management system. It keeps all the code right in the repo, so you can see how
it's working and edit as needed.

### The Admin Controller

The Admin Controller (`app/controllers/admin_controller.rb`) does most of the
heavy lifting with the admin functionality. Have a look if you'd like to see
exactly what it's got going on. The various features available are outlined
below.

### Authentication

As mentioned above, users are authenticated by looking at the `is_admin`
attribute on their user object. The private method `authenticate_admin` first
authenticates a user to ensure they are logged in (using Devise). Once
authenticated, if they are not an admin, they are pushed back to the root path.

```ruby
def authenticate_admin
  authenticate_user!
  redirect_to root_path unless current_user.is_admin?
end
```

You can edit this path if you want to move unauthenticated users elsewhere
(note: if they aren't logged in, they will be redirected to the login form).

### A Simple Controller

The admin controller and views are built to be a base solution, so you have to
do very little to new controllers if you're just looking to get something up and
running quickly. Let's walk through creating a new, simple controller.

Let's say you have a `Page` model and you want to add that to your CMS. You'd
start by creating the controller.

```
$ bundle exec rails g controller admin/pages
```

The first thing you want to do is make sure that controller is inheriting from
`AdminController`. So, the first line of the controller should look like this:

**app/controllers/admin/pages_controller.rb**

```ruby
class Admin::PagesController < AdminController
```

Add the routes, which usually include all the RESTful routes except show (show
is not currently supported in the admin), to the `admin` namespace in the routes
file.

**config/routes.rb**

```ruby
namespace :admin do
  resources :users, :except => [:show]
  resources :pages, :except => [:show]
end
```

Technically, that's all you *have to do* to have a functioning section of the
CMS. You can check it out by (logging in, then) going to
`http://localhost:3000/admin/pages`.

However, there are probably some modification you'll want to make, so let's take
a look at those.

### Navigation Menu

One thing you'll likely always want is a navigation menu item. These items are
driven from the `admin_nav_items` method in the  `app/helpers/nav_helper.rb`
file.

You can add your has to this method to generate a new nav item. For pages, it
might look something like this:

```ruby
{
  :label => 'Pages',
  :icon => 'file',
  :path => admin_pages_path,
  :controllers => ['pages']
},
```

Let's look at each of these items real quick.

* **`label`** is the text displayed by the nav item.
* **`icon`** is the name of the icon displayed above the label. There is more
  documentation on the styles and icons below, but, for now, know you can get
  the name of the icon from [this page](http://icomoon.io/#preview-free). It is
  possible the code does not stay up to date with the icons, but it should
  contain most of the names. We're working on adding an absolute reference to
  the icon names.
* **`path`** is the route name of the page which you want the nav item to lead
  to.
* **`controllers`** drives whether the nav item is active (highlighted). You can
  certainly nest controllers. So, for example, if pages had categories, you
  might want to add `'categories'` to the `:controllers` array. Then, when the
  categories controller is active, then page nav item will be highlighted.

### Overwriting Actions and Methods

A great way to extend the built-in functionality is to overwrite actions and/or
methods from the admin controller.

#### Actions

We have six of the seven REST actions by default (except show). Most of the time
using the default actions should work fine. But, sometimes you need more logic
in your controller. Just add the action to your controller and do what you
normally would.

> Be aware that you probably want to follow the instance variable convention
> already set in place. A collection of your main objects should be called
> `@items` and one main object should be `@item`. This should minimize the work
> you need to do to extend functionality.

For an example, check out `app/controllers/admin/users_controller.rb`. In the
users controller, we needed to overwrite the `update` action because we want to
sign the user back in, but only if they change their own password.

```ruby
def update
  p = update_params
  p = no_pwd_params if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
  if @item.update(p)
    sign_in(@item, :bypass => true) unless p[:password].nil?
    redirect_to @routes[:index], :notice => "#{@model.to_s} was updated successfully."
  else
    @url = @routes[:show]
    render :action => "edit"
  end
end
```

And this is why the only action you see in the users controller is for `update`,
while all the other actions are inheriting from the admin controller.

#### Methods

We have a handful of private routes to assist in building out our controllers.
Adding any of these in your controller will override those in the admin
controller.

And sometimes this is entirely necessary. For example, much of the admin is
driven by the values in the `set_defaults` method, which are meant to be dynamic
and to vary from controller to controller. But, you may not want to override all
the content in the method. So, what we can do is call the admin controller's
method first, and then execute the code in our controller. We do this by
beginning our method with `super`.

Keeping with the pages example, we probably want to change a few values in our
`set_defaults method`. So we might have something like this.

```ruby
class Admin::PagesController < AdminController

  ...

  private

    def set_defaults
      super
      @model = Page
      @columns = ['title','author','updated_at']
    end

    ...

end
```


Another place you might want this is with `create_params` and `update_params`,
both of which use strong parameters to keep your CMS safe. By default, all
attributes on the model are whitelisted, but you can overwrite them by doing
something like this:

```ruby
def create_params
  params.require(:page).permit(:title, :slug, :body, :author_id)
end
```

We've broken out `update_params` because in some cases you need to whitelist
different parameters when updating an object versus creating it. If you don't
write an `update_params` method, it uses `create_params` as a fallback.

### Overwriting Views

You can also overwrite any view you'd like. We're still in the process of
breaking out our main views into different partials. However, for the time
being, you should look within the `app/views/admin` directory to see the
available views (and partials) you can overwrite.

### The Form View

The main partial typically overwritten is the `_form.html.erb` partial. By
default, we're adding all the attributes (except `id`, `created_at`,
`updated_at`) to the form, but that gets ugly very quickly.

Take a look in the `app/views/users/`. You'll see we have `_form.html.erb` and
`_edit_form.html.erb`. We have both because it was cleaner to keep the logic
separate from the two.

#### Form Sections

Forms are built primarily using instance variables and helpers.

The top of the form almost always looks similar.

```erb
<%= simple_form_for @item, :url => @url do |f| %>

...

<% end %>
```

We thought it'd be too confusing to abstract this, so you'll need to add it.

In addition, the sections of the form are built using the `form_section` and
`form_column` helpers. The only difference is the width -- section is 100% and
column is 50%.

Form section takes a `title` and a `&block` as arguments. This means we could do
something like this for our pages example.

```erb
<%= form_section 'title' do %>
  <%= f.input :title, :label => false %>
<% end %>
```

You see this looks a little different from typicaly rails' forms. This is
because we're using [Simple Form](https://github.com/plataformatec/simple_form)
(another awesome gem).

The only other difference between `form_section` and `form_column` is that
`form_column` takes an additional argument -- `'right'` -- for the column on the
right. This just makes it a little easier for us to write the CSS.

```erb
<%= form_column 'title' do %>
  <%= f.input :title, :label => false %>
<% end %>

<%= form_column 'description', 'right' do %>
  <%= f.input :description, :label => false %>
<% end %>
```

#### Pre-Built Fields

And there are a few pre-built fields that can help you writing the same code
over an over. One is a simple rich text editor. You can call this by passing the
form object and the field to the helper.

```erb
<%= form_section 'description' do %>
  <%= wysiwyg(f, :description) %>
<% end %>
```

The default field is `:body`, so if that's your field, you can leave the second
argument blank.

We also have a publishable section for handling publishing objects. First, you
need `active_at` and `inactive_at` as `datetime` fields on your model.

```bash
$ bundle exec rails g migration add_publishable_to_pages active_at:datetime inactive_at:datetime
```

Then add the following, and don't forget to add them to your `create_params`.

```erb
<%= form_section 'publish' do %>
  <%= publishable_fields(f) %>
<% end %>
```

### Sorting Columns

Columns are sortable, but only in the simplest sense now. Just add the columns
to a `set_defaults` variable of `@sortable`, matching the columns you want to be
sortable in the `@columns` array.

```ruby
def set_defaults
  super
  @model = Page
  @columns = ['title','author','updated_at']
  @sortable = ['title','updated_at']
end
```


Common Fields
-----------------------

There are some attributes common among typical models, so we've began writing
some concerns. All you have to do is add the attribute to the database and
include the concern in your model.

### Publishable

Publishable handles the publishing of objects by comparing values in `active_at`
and `inactive_at`, which helps with scheduling the publishing.

You need `active_at` and `inactive_at` as `datetime` fields on your model. Then,
add the following to your model.

```ruby
class Page < ActiveRecord::Base

  include Publishable

  ...

end
```

### Slug

Slug is a helper that conversts the title of the object into a friendly url.
Just make sure you add `title` and `slug` as `string`s on your model, then add
the following:

```ruby
class Page < ActiveRecord::Base

  include Slug

  ...

end
```

`slug` then becomes the default parameter for URLs.

> `slug`, by default, does not have any hooks for creating it. We've found it
> simpler to call its methods when we need to update it. Take a look at how the
> admin controller handles updating the slug.

Styling
-----------------------

We're using Bones for styling. Bones is in its early days still, but it was
written by the same author, so we're sticking with it for now. Check out
[Bones](https://github.com/rocktreedesign/bones) and [Bones-
Rails](https://github.com/rocktreedesign/bones-rails) for more information.
