require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  def test_reset_email
    user = users(:michael)
    user.reset_token = user.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.reset_token         mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end
end
