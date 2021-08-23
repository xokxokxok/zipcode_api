class UserTokenCreator
  attr_reader :user_token, :user, :email, :password

  def self.call(*args)
    new(*args).call
  end

  def initialize(email, password)
    @user_token = UserToken.new
    @user = nil
    @email = email
    @password = password
  end

  def call
    @user = find_user

    return user_token if user.blank?
    return user_token unless valid_password?

    create_user_token
  end

private

  def add_error(key, message)
    @user_token.errors.add(key.to_sym, message)
    false
  end

  def find_user
    user = User.find_by_email(email)
    return user if user.present?

    add_error('user', 'not found')
  end

  def valid_password?
    return true if user.try(:valid_password?, password)

    add_error('password', 'invalid')
  end

  def create_user_token
    UserToken.create(
      user_id: user.id,
      expires_at: DateTime.now + ENV['API_TOKEN_DURATION_MINUTES'].to_i.minutes
    )
  end
end
