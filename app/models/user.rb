class User < ApplicationRecord
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Role-management behaviors.
  include Hydra::RoleManagement::UserRoles

  # Connects this user object to Hyrax behaviors.
  include Hyrax::User
  include Hyrax::UserUsageStats

  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :password, :password_confirmation
  end
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, omniauth_providers: [:openam]

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  def self.find_or_create_system_user(user_key)
    find_or_create_by(Hydra.config.user_key_field => user_key)
  end

  def self.from_omniauth(auth)
    username = auth.uid
    email = auth.info.email

    (User.find_by(username: username) ||
      User.find_by(email: email) ||
      User.create(username: username, email: email)).tap do |user|
        if user.username.nil? || user.email.nil?
          user.username = username
          user.email = email
          user.save
        end
      end
  end
end

class MissingUserId < StandardError; end
