class UserDeviseMailerPreview < ActionMailer::Preview

  def reset_password_instructions
    user = FactoryGirl.create(:user)
    reset_token = 'faketoken'
    UserDeviseMailer.reset_password_instructions(user, reset_token)
  end

end
