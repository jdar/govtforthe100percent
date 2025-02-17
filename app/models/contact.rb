class Contact < MailForm::Base
  attribute :name, validate: true
  attribute :email, validate: URI::MailTo::EMAIL_REGEXP
  attribute :travesty_id, allow_blank: true
  attribute :travesty_name, allow_blank: true
  attribute :message
  attribute :nickname, captcha: true

  validate :travesty_must_exist

  def travesty_must_exist
    return if travesty_id.blank?
    return if Travesty.exists?(id: travesty_id, name: travesty_name)

    errors.add(:base, "Must be valid travesty ID and name")
  end

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      subject: "My Contact Form #{travesty_id}",
      to: "refugetravesties@gmail.com",
      from: %("#{name}" <#{email}>), # :from overriden by google smtp config
      reply_to: %("#{name}" <#{email}>)
    }
  end
end
