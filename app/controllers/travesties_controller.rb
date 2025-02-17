require_relative '../helpers/recaptcha_helper'

# rubocop:disable Metrics/ClassLength
class TravestiesController < ApplicationController
  respond_to :html, :json

  before_action :travesties_filters, only: [:index]
  before_action :list_travesties, only: [:index]
  before_action :find_travesty, only: %i[show update edit]

  def index
    @view = params[:view] || 'list'
    if params[:nearby]
      render :nearby, layout: false
    else
      respond_with @travesties
    end
  end

  def show; end

  # rubocop:disable Metrics/MethodLength
  def new
    if params[:edit_id]
      @travesty = find_travesty
      @travesty.edit_id = params[:edit_id]
      @travesty.approved = false
    elsif params[:guess]
      @travesty = Travesty.new(permitted_params)
      @travesty.reverse_geocode
      render 'new', layout: false
    else
      @travesty = Travesty.new
    end
  end
  # rubocop:enable Metrics/MethodLength

  def edit; end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def create
    @travesty = Travesty.new(permitted_params)

    # Verify recaptcha code
    recaptcha_response = params['g-recaptcha-response']
    unless RecaptchaHelper.valid_token? recaptcha_response
      flash.now[:error] = I18n.t('helpers.reCAPTCHA.failed')
      render 'new'
      return
    end

    @travesty = SaveTravesty.new(@travesty).call

    if @travesty.errors.empty?
      if @travesty.approved?
        flash[:notice] = I18n.t('travesty.flash.new', name: @travesty.name)
        redirect_to @travesty
      else
        flash[:notice] = I18n.t('travesty.flash.edit', name: @travesty.name)
        redirect_to travesty_path(@travesty.edit_id)
      end
    elsif @travesty.errors.key?(:spam)
      flash.now[:notice] = I18n.t('travesty.flash.spam')
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
    if params[:travesty][:downvote]
      Travesty.increment_counter(:downvote, @travesty.id) # rubocop:disable Rails/SkipsModelValidations
    elsif params[:travesty][:upvote]
      Travesty.increment_counter(:upvote, @travesty.id) # rubocop:disable Rails/SkipsModelValidations
    elsif @travesty.update(permitted_params)
      flash.now[:notice] = I18n.t('travesty.flash.updated')
    else
      display_errors
      render 'edit'
    end

    redirect_to @travesty
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  def travesties_filters
    @filters =
      params
      .fetch(:filters, '')
      .split(',')
      .each_with_object({}) do |filter, filters|
        filters[filter] = true if %w[accessible changing_table unisex].include?(filter)
      end
  end

  # rubocop:disable Metrics/AbcSize
  def list_travesties
    @travesties = Travesty.current.where(@filters)
    @travesties =
      if params[:search].present? || params[:map] == "1"
        @travesties.near([params[:lat], params[:long]], 20, order: 'distance')
      else
        @travesties.reverse_order
      end
    @pagy, @travesties = pagy(@travesties)[0].overflow? ? pagy(@travesties, page: 1) : pagy(@travesties)
  end
  # rubocop:enable Metrics/AbcSize

  def display_errors
    if @travesty.errors.any?
      @travesty.errors.each do
        flash[:alert] = I18n.t('travesty.flash.field')
      end
    else
      flash[:alert] = I18n.t('travesty.flash.unexpected')
    end
  end

  def find_travesty
    @travesty = Travesty.find(params[:id])
  end

  # rubocop:disable Metrics/MethodLength
  def permitted_params
    params.require(:travesty).permit(
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
