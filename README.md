# orchestrator

Allow you to split your logic into composable multiple pieces.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  orchestrator:
    github: alex-lairan/orchestrator
```

## Usage

```crystal
require "orchestrator"
```

You have to create layers

```crystal
class Registrator < Orchestrator::Layer
  def call(input : Hash)
    # logic here

    # in case of success
    return Monads::Success.new(input)

    # in case of failure
    return Monads::Failure.new(input)
  end
end

class Validator < Orchestrator::Layer
  def call(input : Hash)
    # logic here

    # in case of success
    return Monads::Success.new(input)

    # in case of failure
    return Monads::Failure.new(input)
  end
end
```

Then create a composer

```crystal
class UserRegistration < Orchestrator::Composer
  compose :validation, klass: Validator
  compose :registration, klass: Registrator
end
```

That it, now call this super class !

```crystal
composer = UserRegistration.new
result = composer.call(data)

if result.success?
  # If success
else
  # If failure
end
```

## Development

Do what ever you want.

## Contributing

1. Fork it (<https://github.com/alex-lairan/orchestrator/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [alex-lairan](https://github.com/alex-lairan) Alexandre Lairan - creator, maintainer
