# https://github.com/plataformatec/devise/blob/master/app/controllers/devise/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  def create
    resource = resource_class.where(autogenerated: true).where('lower(name) = ?', sign_up_params[:name].downcase).first
    if resource
      resource.email = nil
      resource.password = nil
      resource.assign_attributes(sign_up_params)
      resource.autogenerated = false
      self.resource = resource
      if resource.save
        sign_up(resource_name, resource)
        render :signed_up_autogenerated
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    else
      super
    end
  end
end