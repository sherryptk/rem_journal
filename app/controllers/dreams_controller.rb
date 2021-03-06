require 'sinatra/base'
require 'rack-flash'

class DreamsController < ApplicationController
  enable :sessions
  use Rack::Flash

  get '/dreams' do
    if logged_in?
      @user = current_user
      erb :'/dreams/dreams'
    else
      flash[:message] = "You must first login"
      redirect '/login'
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
    if params[:dream][:story] == "" || params[:dream][:date] == "mm/dd/yyyy" || params[:dream][:date] == ""
      flash[:message] = "Be sure not to leave any fields blank before submitting."
      redirect to '/dreams/new'
    else
      @dream = current_user.dreams.create(params[:dream])
      id = @dream.id
    if !params[:theme][:name].empty?
      @dream.themes << Theme.find_or_create_by(name: params[:theme][:name])
      flash[:message] = "You have successfully logged a dream!"
    end
      redirect to "/dreams/#{id}"
    end
  end

  get '/dreams/:id' do
    if current_dream
      if logged_in?
        @dream = current_dream
        erb :'/dreams/show_dream'
      else
        redirect to '/login'
      end
    else
      redirect to '/dreams'
    end
  end

  get '/dreams/:id/edit' do
    if logged_in?
      @dream = current_dream
      erb :'dreams/edit_dream'
    else
      redirect to '/login'
    end
  end

  patch '/dreams/:id' do
    @dream = current_dream

    if valid_user
      id = @dream.id
      updated_themes = []

      if params[:story] == ""
        flash[:message] = "You haven't made any changes!"
        redirect to "/dreams/#{id}/edit"
      else
        @dream.update(params[:dream])

        if params[:dream][:theme_ids] != nil
          params[:dream][:theme_ids].each do |theme_id|
          updated_themes << Theme.all.find(theme_id)
        end
          @dream.themes = updated_themes
        end

        if !params[:theme][:name].empty?
          @dream.themes << Theme.find_or_create_by(name: params[:theme][:name])
        end

        @dream.save
        flash[:message] = "You have successfully updated a dream!"
        redirect to "/dreams/#{id}"
      end
      redirect to "/dreams"
    else
      flash[:message] = "You cannot edit another user's dream."
      redirect to '/dreams'
    end
  end

  delete '/dreams/:id/delete' do
    @dream = current_dream
    if valid_user
      @dream.destroy
      redirect to "/dreams"
    else
      flash[:message] = "You cannot delete another user's dream."
      redirect to '/dreams'
    end
  end

end
