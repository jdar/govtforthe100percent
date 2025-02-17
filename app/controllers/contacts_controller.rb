require_relative '../helpers/recaptcha_helper'

class ContactsController < ApplicationController
  def new
    @contact = Contact.new(travesty_id: params['travesty_id'], travesty_name: params['travesty_name'])
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def create
    @contact = Contact.new(params[:contact])
    unless @contact.valid?
      flash.now[:error] = I18n.t('contacts.submitted.cannot-send')
      render :new
      return
    end

    # Verify recaptcha code
    recaptcha_response = params['g-recaptcha-response']
    unless RecaptchaHelper.valid_token? recaptcha_response
      flash.now[:error] = I18n.t('helpers.reCAPTCHA.failed')
      render :new
      return
    end

    @contact.request = request
    @contact.deliver
    flash.now[:error] = nil
    flash.now[:notice] = I18n.t('contacts.submitted.thank-you-exclamation')
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
end
