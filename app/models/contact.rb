class Contact < MailForm::Base
  attribute :name, validate: true
  attribute :email, validate: URI::MailTo::EMAIL_REGEXP
  attribute :experience_id, allow_blank: true
  attribute :experience_name, allow_blank: true
  attribute :message
  attribute :nickname, captcha: true

  validate :experience_must_exist

  def experience_must_exist
    return if experience_id.blank?
    return if Experience.exists?(id: experience_id, name: experience_name)

    errors.add(:base, "Must be valid experience ID and name")
  end

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      subject: "My Contact Form #{experience_id}",
      to: "refugeexperiences@gmail.com",
      from: %("#{name}" <#{email}>), # :from overriden by google smtp config
      reply_to: %("#{name}" <#{email}>)
    }
  end
end
