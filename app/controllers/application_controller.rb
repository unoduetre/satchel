# frozen_string_literal: true

# Application Controller
class ApplicationController < ActionController::Base
  protected

  def internal_server_error(exception)
    logger.error(exception.full_message)
    render plain: t('errors.internal_server_error'), status: :internal_server_error
  end

  def not_found(_exception)
    render plain: t('errors.not_found'), status: :not_found
  end
end
