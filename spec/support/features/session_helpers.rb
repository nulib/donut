module Features
  # Provides methods for login and logout within Feature Tests
  module SessionHelpers
    # Regular login
    def login_as(user)
      user.reload # because the user isn't re-queried via Warden
      super(user, scope: :user, run_callbacks: false)
    end

    # Regular logout
    def logout(user = :user)
      super(user)
    end
  end
end
