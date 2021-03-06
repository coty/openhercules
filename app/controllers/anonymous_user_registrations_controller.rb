class AnonymousUserRegistrationsController < ApplicationController
  before_filter :authenticate_user!, :only => [:update]
  skip_before_filter :verify_authenticity_token
  
  layout "spare"
  
  def create
    user = User.create_anonymous_user
    sign_in(user)
    redirect_to lists_path
  end
  
  def edit
  end
  
  def update
    params[:user].merge!({
      anonymous: false,
      current_password: "anonymous",
      remember_me: true
    })
    
    if current_user.update_with_password(params[:user])
      sign_in :user, current_user, :bypass => true
      redirect_to lists_path
    else
      current_user.clean_up_passwords
      render :edit
    end
  end
  
end
