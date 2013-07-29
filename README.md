# Qs::Test::Harness

The harness mounts all necessary apps of our system, creates users, tokens, etc. and provides you with an instance of rack-client that uses an OAuth token injector.

## Initialize the harness first

```ruby
Qs::Test::Harness.setup! do
  # Provide a multitude of apps as a dependency for the actual test
  provide Qs::Test::Harness::Provider::Datastore
  provide Qs::Test::Harness::Provider::Graph
  provide Qs::Test::Harness::Provider::Devcenter
  provide Qs::Test::Harness::Provider::Playercenter

  # The rack app that is going to be tested
  test Admin::Backend::API
end
```

## Issue requests to the mounted system

```ruby
harness = Qs::Test::Harness.harness
client = harness.client
client.get '/v1/insights'
```

### Use authorized requests

```ruby
user = harness.entity_factory.create(:user)
client.authorize_with(user.token)
client.get '/v1/insights'
client.reset_authorization
```

### Authorize in a given block

This will reset the authorization to whatever it was before the call to ``authorize_as``.

```ruby
client.authorize_with(harness.provider(:auth).system_access) do |client|
  client.get '/v1/insights'
end
```

### Create a game

```ruby
harness.entity_factory.create(:game)
# or with optional parameters
harness.entity_factory.create(:game, "name" => "Top Shot Runner")
```

Make sure to use strings and **not** symbols.

You can specify venues as an array of venue ids and it will create the necessary config for you:

```ruby
# create a game enabled on facebook and as an embeddable
harness.entity_factory.create(:game, "venues" => ['facebook', 'embedded'])
```

### Create a developer

```ruby
harness.entity_factory.create(:developer)
```

### Create a player

```ruby
harness.entity_factory.create(:player)
```