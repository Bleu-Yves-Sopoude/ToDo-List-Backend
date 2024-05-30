# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, options = {})
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'User signed up successfully',
                  data: resource }
      }, status: :ok
    elsif resource.errors.any? && resource.errors[:email].include?('has already been taken')
      render json: {
        status: { message: 'User could not be created successfully. Email is already taken.',
                  errors: resource.errors.full_messages }
      }, status: :unprocessable_entity
    else
      render json: {
        status: { message: 'User could not be created successfully',
                  errors: resource.errors.full_messages }
      }, status: :unprocessable_entity
    end
  end
end
