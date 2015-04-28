module UsersHelper

  def mock_logged_in_admin
    admin = double(User)
    allow(admin).to receive(:id).and_return(1)
    allow(admin).to receive(:admin).and_return(true)
    allow(admin).to receive(:password_changed?).and_return(true)
    allow_message_expectations_on_nil # suppress warnings on devise warden
    allow(request.env['warden']).to receive(:authenticate!).and_return(admin)
    return admin
  end

  def mock_logged_in_user
    user = double(User)
    allow(user).to receive(:id).and_return(1)
    allow(user).to receive(:admin).and_return(false)
    allow(user).to receive(:password_changed?).and_return(true)
    allow_message_expectations_on_nil # suppress warnings on devise warden
    allow(request.env['warden']).to receive(:authenticate!).and_return(user)
    return user
  end

  def mock_new_user
    user = double(User)
    allow(user).to receive(:id).and_return(1)
    allow(user).to receive(:admin).and_return(true)
    allow(user).to receive(:password_changed?).and_return(false)
    allow_message_expectations_on_nil # suppress warnings on devise warden
    allow(request.env['warden']).to receive(:authenticate!).and_return(user)
    return user
  end

end
