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
      @dream = current_user.dreams.create(date: params["date"], story: params["story"] )
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

  get '/dreams/:id/edit' do
    if logged_in?
      @dream = Dream.all.find(params[:id])
      erb :'dreams/edit_dream'
    else
      redirect to '/login'
    end
  end

  patch '/dreams/:id' do
    @dream = Dream.all.find(params[:id])
    id = @dream.id

    if params[:story] == ""
      redirect to "/dreams/#{id}/edit"
    else
      @dream.update(params["dream"])
      if !params["dream"]["theme"].empty?
      @dream.themes << Theme.create(name: params["theme"]["name"])
      end
      @dream.save
      redirect to "/dreams/#{id}"
    end
  end

end
