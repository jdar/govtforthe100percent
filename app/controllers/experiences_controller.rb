require_relative '../helpers/recaptcha_helper'
require_relative 'zip_lookup_controller'

# rubocop:disable Metrics/ClassLength
class ExperiencesController < ApplicationController
  respond_to :html, :json

  before_action :experiences_filters, only: [:index]
  before_action :list_experiences, only: [:index]
  before_action :find_experience, only: %i[show update edit]

  def index
    @view = params[:view] || 'list'
    if params[:nearby]
      render :nearby, layout: false
    else
      respond_with @experiences
    end
  end

  def show; end

  # rubocop:disable Metrics/MethodLength
  def new
    if params[:edit_id]
      @experience = find_experience
      @experience.edit_id = params[:edit_id]
      @experience.approved = false
    elsif params[:guess]
      @experience = Experience.new(permitted_params)
      @experience.reverse_geocode
      render 'new', layout: false
    else
      @experience = Experience.new
    end
  end
  # rubocop:enable Metrics/MethodLength

  def edit; end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def create
    @experience = Experience.new(permitted_params)

    # Verify recaptcha code
    recaptcha_response = params['g-recaptcha-response']
    if Rails.env.production?
      unless RecaptchaHelper.valid_token? recaptcha_response
        flash.now[:error] = I18n.t('helpers.reCAPTCHA.failed')
        render 'new'
        return
      end
    end

    @experience = SaveExperience.new(@experience).call

    if @experience.errors.empty?
      if @experience.approved?
        flash[:notice] = I18n.t('experience.flash.new', name: @experience.name)
        redirect_to @experience
      else
        flash[:notice] = I18n.t('experience.flash.edit', name: @experience.name)
        redirect_to experience_path(@experience.edit_id)
      end
    elsif @experience.errors.key?(:spam)
      flash.now[:notice] = I18n.t('experience.flash.spam')
      render 'new'
    else
      display_errors
      render 'new'
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def update
    if params[:experience][:downvote]
      Experience.increment_counter(:downvote, @experience.id) # rubocop:disable Rails/SkipsModelValidations
    elsif params[:experience][:upvote]
      Experience.increment_counter(:upvote, @experience.id) # rubocop:disable Rails/SkipsModelValidations
    elsif @experience.update(permitted_params)
      flash.now[:notice] = I18n.t('experience.flash.updated')
    else
      display_errors
      render 'edit'
    end

    redirect_to @experience
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  def experiences_filters
    @filters =
      params
      .fetch(:filters, '')
      .split(',')
      .each_with_object({}) do |filter, filters|
        filters[filter] = true if %w[accessible changing_table unisex].include?(filter)
      end
  end

  # rubocop:disable Metrics/AbcSize
  def list_experiences
    @experiences = Experience.current.where(@filters)
    @experiences =
      if params[:search].present? || params[:map] == "1"
        @experiences.near([params[:lat], params[:long]], 20, order: 'distance')
      else
        @experiences.reverse_order
      end
    @pagy, @experiences = pagy(@experiences)[0].overflow? ? pagy(@experiences, page: 1) : pagy(@experiences)
  end
  # rubocop:enable Metrics/AbcSize

  def display_errors
    if @experience.errors.any?
      @experience.errors.each do
        flash[:alert] = I18n.t('experience.flash.field')
      end
    else
      flash[:alert] = I18n.t('experience.flash.unexpected')
    end
  end

  def find_experience
    @experience = Experience.find(params[:id])
  end

  # rubocop:disable Metrics/MethodLength
  def permitted_params
    params.require(:experience).permit(
      :zip_code,
      :federal_agency,
      :agency_website, 
      :immediate_results, 
      :experience,
      :experience_details,
      :open_to_contact,
      :contact_name,
      :contact_email,
      :contact_phone,

      :name,
      :street,
      :city,
      :state,
      :country,
      :accessible,
      :changing_table,
      :unisex,
      :directions,
      :comment,
      :longitude,
      :latitude,
      :edit_id,
      :approved
    )
  end
  # rubocop:enable Metrics/MethodLength
end
# rubocop:enable Metrics/ClassLength
