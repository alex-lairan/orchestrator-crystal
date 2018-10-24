USERS = [] of User

struct User
  def initialize(@name : String, @email : String)
  end
end

class ValidUserData < Orchestrator::Layer
  def call(input)
    if input.has_key?(:name) && input.has_key?(:email)
      Monads::Success.new(input)
    else
      Monads::Failure.new(:validation_error)
    end
  end
end

class PersistUser < Orchestrator::Layer
  def call(input)
    name = input[:name]
    email = input[:email]

    if name.is_a?(String) && email.is_a?(String)
      user = User.new(name, email)
      USERS << user

      Monads::Success.new(input.merge({ :user => user }))
    else
      Monads::Failure.new(:persist_error)
    end
  end
end

class UserComposer < Orchestrator::Composer
  compose :validation, klass: ValidUserData
  compose :persist, klass: PersistUser
end
