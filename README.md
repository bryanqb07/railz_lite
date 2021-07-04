# RailzLite

A lite-weight Ruby gem inspired by Ruby on Rails.  

To get started with a new project, execute the command

```
$ railz_lite new MyWebApp
```

This will generate controllers/, views/, models/, and other necessary directories.

After changing into the root project directory, run the server command to get the Rack server running

```
$ cd MyWebApp && railz_lite server
```

To create a new sqlite3 database file, write your desired SQL code in app.sql then execute

```
$ railz_lite reset_db
```

An example web app can be found at the following repo:

https://github.com/bryanqb07/trash_films

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'railz_lite'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install railz_lite

## Usage

### Controllers

All controllers should inherit from the RailzLite::ControllerBase class. An example is as follows:

```ruby
 class FilmsController < RailzLite::ControllerBase
   def index
     @films = Film.all
   end

   def show
     @film = Film.find(params['id'])
   end
 end
```

### Models

Models inherit from RailzLite::SQLObject. Please note that any class declaration must be ended with a finalize! statement

```ruby
class Film < RailzLite::SQLObject
  has_many :reviews, foreign_key: :film_id
  def average_rating
    ratings = reviews.map(&:rating)
    return 0 if ratings.empty?
    
    ratings.reduce(:+) / reviews.length
  end
  finalize!
end
```

### Views 

Views use the rails convention for path-resolution. Also, they are required to end in a .erb extension, even if no embedded ruby is used.  

ex. FilmsController#index corresponds to /views/films/index.html.erb

### Server + Routes

The server file can be found in config/server. 

Routes are configured in the following structure 

```
http_method, regex to match route, controller, action
```

Below is an example route config:
```ruby
router.draw do
  # add routes here
  get Regexp.new('^/films$'), FilmsController, :index
  get Regexp.new("^/films/(?<id>\\d+)$"), FilmsController, :show

  get Regexp.new("^/films/(?<film_id>\\d+)/reviews/new$"), ReviewsController, :new
  post Regexp.new("^/films/(?<film_id>\\d+)/reviews$"), ReviewsController, :create
end
```

### Assets

Assets are served via the static middleware included within the framework. The default load paths for assets are "/public" and "/assets".
Any file within these two folders can be accessed in the app by specifying the root folder + the file name.

ex.) MyProject/public/balloons.jpg

```html
<h1>Congratulations!!! <img src="public/balloons.jpg" /></h1>
```

ex.) MyProject/assets/home.css

```html
  <head>
    <title>My Project</title>
    <link rel="stylesheet" href="assets/application.css">
  </head>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bryanqb07/railz_lite. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/bryanqb07/railz_lite/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RailzLite project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bryanqb07/railz_lite/blob/master/CODE_OF_CONDUCT.md).
