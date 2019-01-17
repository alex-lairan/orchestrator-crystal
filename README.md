# orchestrator

Allow you to split your logic into multiple composable pieces.

Each meta-action in your application is represented by a Composer, like *Create a user*, *Call external API*.
A composer use sub-logic classes called a Layer.
A layer will be like *Validate user input*, *Format data*, *Save objects into database*

Example :

Composer -> CreateUser


Layers ->
- ValidateUserData
- CheckIfEmailExist
- BuildUserDependencies
- SaveUserToDatabase

Composer -> UpdateUser


Layers ->
- FindUser
- ValidateUserData
- SaveUserToDatabase

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  orchestrator:
    github: alex-lairan/orchestrator-crystal
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

That it, now call this orchestrator class !

```crystal
composer = UserRegistration.new
result = composer.call(data)

if result.success?
  # If success
else
  # If failure
end
```

The result is a Monads::Result object, you can use any methods from it.

### Advanced layer usage

You can specify what kind of parameters you want for this layer

```crystal
class PropertyLayer < Orchestrator::Layer
  required name, String
  optional option, Bool

  def call(input : Hash)
    if option
      Monads::Success.new(input.merge({ :option_in => true }))
    else
      Monads::Success.new(input.merge({ :option_in => false }))
    end
  end
end
```

When you call it with the `perform` method, it prepare all the environment for you.

If `name` is missing, it return you a `Monads::Failure("name is missing")`

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
