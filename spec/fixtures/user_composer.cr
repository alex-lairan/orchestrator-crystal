USERS = [] of User

struct User
  getter email : String

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

class UserUnicity < Orchestrator::Layer
  def call(input)
    email = input[:email]

    if email.is_a?(String)
      if USERS.any? { |u| u.email == email }
        Monads::Success.new(input)
      else
        Monads::Failure.new(:email_duplicated)
      end
    else
      Monads::Failure.new(:email_missing)
    end
  end
end

class RegistrationComposer < Orchestrator::Composer
  compose :verify_entry, klass: UserUnicity
  compose :register, composer: UserComposer.new
end
