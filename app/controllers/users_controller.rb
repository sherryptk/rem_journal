class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect to '/tweets'
    end
    erb :'/users/create_user'
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
