class Mailer < ActionMailer::Base
  def test_email
    mail to: 'test@test.com', subject: 'Test'
  end
end
