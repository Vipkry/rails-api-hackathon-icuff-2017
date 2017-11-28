class UsersController < ApplicationController

  skip_before_action :authenticate, :only => [:create, :authenticate]

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)
    @user.teacher_id = 0;

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # POST /login
  def authenticate
    user = User.find_by(reg: params[:reg])
    @ans = false
    if user && user.authenticate(params[:password])
      @ans = true
      render json: @ans
    else
      render json: @ans
    end

    command = AuthenticateUser.call(params[:id_nat], params[:password])
    
    if command.success?
      render json: { auth_token: command.result }, status: 200
    else 
      render json: { error: command.errors }, status: 401 
    end
    
  end
  
  # GET /users_reg
  def users_reg
    render json: @current_user
  end

  # DELETE /users/1
  def destroy
    #@user.destroy
  end
  
  # POST /change 
  def change
    @aux = false
    user = @current_user
    if user && user.authenticate(params[:password])
      if params[:password_new] == params[:password_new_confirmation]
        user.update(:password => params[:password_new])
        @aux = true
      end
    end
    
    render json: @aux
  end

  private
    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :reg, :admin, :password)
    end
end
