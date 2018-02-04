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

  get '/login' do
  if logged_in?
    redirect to '/dreams'
  else
    erb :'/users/login'
  end
end

  post '/login' do
    @user = User.find_by(username: params["username"])
    if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect to '/dreams'
    else
        redirect "/login"
    end
  end

  get '/logout' do
    session.clear
    redirect '/login'
  end

  get '/dreams/new' do
    if logged_in?
      erb :'/dreams/create_dream'
    else
      redirect to '/login'
    end
  end

  post '/dreams' do
    if params[:content] == ""
      redirect to '/dreams/new'
    else
      @dream = current_user.dreams.create(:date=> params["date"], :content=> params["content"])
      id = @dream.id
      redirect to "/dreams/#{id}"
    end
  end

  get '/dreams/:id' do
    if logged_in?
      @dream = Dream.all.find(params[:id])
      erb :'/dreams/show_dream'
    else
      redirect to '/login'
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
