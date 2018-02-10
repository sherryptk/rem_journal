require 'sinatra/base'
require 'rack-flash'

class UsersController < ApplicationController
  enable :sessions
  use Rack::Flash

  get '/signup' do
    if logged_in?
      redirect to '/dreams'
    end
      erb :'/users/create_user'
  end

  post '/signup' do
    if params[:username] == '' || params[:email] == '' || params[:password] == ''
      flash[:message] = "Be sure not to leave any fields blank before submitting!"
      redirect to '/signup'
    elsif User.find_by(username: params[:username])
      flash[:message] = "That username is already taken. Please choose another."
      redirect to '/signup'
    else
      @user = User.create(username: params[:username], email: params[:email], password: params[:password])
      session[:user_id] = @user.id
      flash[:message] = "You have successfully signed up!"
      redirect to '/dreams'
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
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        flash[:message] = "You have successfully logged in!"
        redirect to '/dreams'
    else
        flash[:message] = "Sorry, invalid login. Please try again."
        redirect "/login"
    end
  end

  get '/logout' do
    if !logged_in?
      flash[:message] = "You must first login"
      redirect '/login'
    else
      session.clear
      flash[:message] = "You have successfully logged out!"
      redirect '/login'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'/users/show'
  end

end
