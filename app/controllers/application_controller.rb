
class ApplicationController < Sinatra::Base


  register Sinatra::ActiveRecordExtension
  enable :sessions
  set :session_secret, "my_application_secret"
  set :views, Proc.new { File.join(root, "../views/") }


  get '/' do
    erb :index
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def current_dream
      Dream.all.find(params[:id])
    end

    def valid_user
      logged_in? && current_user.id == @dream.user.id
    end
  end

end
