class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect to '/dreams'
    end
    erb :'/users/create_user'
  end

  post '/signup' do
    if params[:username] == '' || params[:email] == '' || params[:password] == ''
    redirect to '/signup'
    else
      @user = User.create(username: params["username"], email: params["email"], password: params["password"])
        session[:user_id] = @user.id
        redirect to '/dreams'
    end
  end

  get '/dreams' do
    if logged_in?
      @user = current_user
      erb :'/dreams/dreams'
    else redirect '/login'
    end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
