[![CircleCI](https://circleci.com/gh/WeInfuse/updox.svg?style=svg)](https://circleci.com/gh/WeInfuse/updox)

# Updox
Ruby API wrapper for [Updox](https://updoxqa.com/api/newio)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'updox'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install updox

## Usage

### Setup

Make sure you're [configured](#configuration)!

```ruby
auth = Updox::Models::Auth.new

response = auth.ping # No authentication needed!

response = auth.ping_with_application_auth # Check if you're app auth is working!
```

### Practice
The practice is what Updox calls 'Account' access so anywhere the `account_id` is required is relating back to this practice instance.

#### Create
```ruby
practice = Updox::Models::Practice.new(name: 'LOL LTD', account_id: '0001', active: true)
practice.create
```

#### List
```ruby
practices = Updox::Models::Practice.query.practices
```

#### Find
```ruby
practice = Updox::Models::Practice.find('0001')
```

### Location

#### Create

```ruby
location = Updox::Models::Location.new(active: true, name: 'My Location', code: 'ML01', id: '27')
location.save(account_id: practice.account_id)

# Bulk
Location.sync([l0, l1], account_id: practice.account_id)
```

#### Query
```ruby
locations = Updox::Models::Location.query(account_id: '0001')
```

#### Find
There is no `find` in the api, we are doing a ruby `find` on the query - so use the `cached_query` option if you are doing a bunch of lookups

```ruby
location = Updox::Models::Location.find(27, account_id: '0001')

cached_query_results = Updox::Models::Location.query(account_id: '0001')

10.times do |id|
  Updox::Models::Location.find(id, account_id: '0001', cached_query: cached_query_results)
end
```

#### Exists?
See note on [Location#find](#location_find) method about caching

```ruby
Updox::Models::Location.exists?(27, account_id: '0001')

cached_query_results = Updox::Models::Location.query(account_id: '0001')

10.times do |id|
  Updox::Models::Location.exists?(id, account_id: '0001', cached_query: cached_query_results)
end
```

### Calendar
See [Location](#location) for simliar #query, #find and #exists? methods

#### Create

```ruby
calendar = Updox::Models::Calendar.new(active: true, title: 'My Calendar', id: 'C1')
calendar.create(account_id: practice.account_id)
```

### Patient

#### Create

```ruby
patient = Updox::Models::Patient.new(id: 'X0001', internal_id: 'X0001', first_name: 'Brian', last_name: 'Brianson', mobile_number: 5126914360, active: true)
patient.save(account_id: practice.account_id)

# Bulk
Patient.sync([p0, p1, p2], account_id: practice.account_id)
```

### Appointment

#### Create

```ruby
appointment = Updox::Models::Appointment.new(id: 'A0001', calendar_id: calendar.id, date: Time.now + 20, duration: 60, location_id: location.id, patient_id: patient.id)
appointment.save(account_id: practice.account_id)

# Bulk
Appointment.sync([appt0, appt1, appt2], account_id: practice.account_id)
```

### Response
By default we usually return `Updox::Models::Model.from_response`

This class throws if throw an exception on non 200 responses with a parsed error.

Updox usually returns a `200` with error information even on things like `Unauthorized`. So you may have to check the updox status via `successful?` method.

If HTTP 200 it adds helper methods and converts each to the respective class.

The raw response is stored in the resulting model but you can get the raw response by setting config option to false

```ruby
response = Updox::Models::Practice.query
response.practices # Has the practices as Updox::Models::Practice model
response.items # Same as practices, always exists on any model if alias is broken
response.item  # If there is no array, we populate this object

response.successful? # Indicates Updox successful indication
response.response_code? # Indicates Updox response code
response.response_message? # Indicates Updox response message

response.response # Raw HTTParty response is here
```

### Configuration

```ruby
Updox.configure do |c|
  c.application_id       = ENV['UPDOX_APP_ID']
  c.application_password = ENV['UPDOX_APP_PASS']
  c.api_endpoint = 'http://hello.com' # Defaults to Updox endpoint
  c.parse_responses = false # Defaults to true
  c.failure_action = :raise # Defaults to do nothing and allows lambdas
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/WeInfuse/updox.
