class RegistrationsController < Devise::RegistrationsController
  protected

  # Overwrite update_resource to let users to update their user without giving their password
  def update_resource(resource, params)
    if resource.uid && resource.provider
      resource.update_without_password(params)
    else
      resource.update_with_password(params)
    end
  end
end