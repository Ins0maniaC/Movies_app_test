class SessionsController < ApplicationController
    skip_before_action	:verify_authenticity_token  
    swagger_controller	:session,	"Authentication"
    before_action :require_token, only: [:destroy]
    def new
    end
    swagger_api	:create	do
	  summary	"Gather	a	token"
      param	:form,	"session[index]",	:string,	:required,	"Users	index"
	  param	:form,	"session[password]",	:string,	:required,	"Users	password"
	end
  def create
    respond_to do |format|
    user = User.find_by(index: params[:session][:index])
    if user && user.authenticate(params[:session][:password])
      # Wszystko dobrze, logujemy
      format.html do
        log_in user
        redirect_to user
      end
      format.json do
        user.password = params[:session][:password]
        user.regenerate_token
        render json: { token: user.token }
      end
    else
      # Niedobrze
      format.html do      
        render 'new'
      end
      format.json do
        render json: { message: 'Niepoprawne dane'}
      end
    end
  end
end

  swagger_api :destroy do
    summary "Invalidate a token"
    param :header, "Authorization", :string, :required, "Authentication token"
  end
  def destroy
    respond_to do |format|
      format.html do
        log_out
        redirect_to root_url
      end
      format.json do
        require_token
        if current_user
          current_user.invalidate_token
          head :ok
        end
      end
    end
  end
end
