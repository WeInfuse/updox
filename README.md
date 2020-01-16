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
patient = Updox::Models::Patient.new
patient.demographics.first_name = 'Joe'
patient.demographics['LastName'] = 'Joerson'
patient.add_identifier(type: 'TheType', value: 'x13005')

meta = Updox::Models::Meta.new
meta.set_source(name: 'MySource', id: '123-584')
meta.add_destination(name: 'TheDest', id: '973-238')
```

### Create

```ruby
response = patient.create(meta: meta)
```

### Update

```ruby
response = patient.update(meta: meta)
```

### Search

```ruby
response = Updox::Models::Patient.query(patient, meta: meta)
```

### Response

The response object is a base `Updox::Models::Model` class.

With the HTTParty response object
```ruby
response.response
#<HTTParty::Response:0x7fa354c1fbe8>

response.response.ok?
true
```

And any `Model` objects that were returned
```ruby
response.patient
{
  "Identifiers"=> [
      {"IDType"=>"MR", "ID"=>"0000000003"},
      {"ID"=>"e3fedf48-c8bf-4728-845f-cb810001b571", "IDType"=>"EHRID"}
    ],
  "Demographics"=> {
    "Race"=>"Black",
    "SSN"=>"303-03-0003",
    "Nickname"=>"Walt"
...
  }
  "PCP"=> {
    "NPI"=>nil,
  }
}

response.meta
{
  "EventDateTime"=>"2019-04-26T20:03:00.304866Z",
  "DataModel"=>"PatientAdmin",
  ...
  "Transmission"=>{"ID"=>797225234},
  "Message"=>{"ID"=>1095117817}
}
```

### Configuration

```ruby
Updox.configure do |c|
  c.api_key      = ENV['UPDOX_API_KEY']
  c.secret       = ENV['UPDOX_SECRET']
  c.api_endpoint = 'http://hello.com' # Defaults to Updox endpoint
  c.token_expiry_padding = 120 # Defaults to 60 seconds
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/WeInfuse/updox.
