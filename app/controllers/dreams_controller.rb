class DreamsController < ApplicationController

  get '/dreams' do
    if logged_in?
      @user = current_user
      erb :'/dreams/dreams'
    else redirect '/login'
    end
  end

  get '/dreams/new' do
    if logged_in?
      @themes = Theme.all
      erb :'/dreams/create_dream'
    else
      redirect to '/login'
    end
  end

  post '/dreams' do
    if params[:content] == ""
      redirect to '/dreams/new'
    else
      # @dream = current_user.dreams.create(:date=> params["date"], :content=> params["content"])

      @dream = current_user.dreams.create(params["dream"])
      id = @dream.id
      if !params["theme"]["name"].empty?
      @dream.themes << Theme.create(name: params["theme"]["name"])
    end
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

end
