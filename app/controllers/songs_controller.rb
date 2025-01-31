require 'rack-flash'
require 'pry'

class SongsController < ApplicationController
    
    use Rack::Flash
    
    configure do
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "auth_demo_lv"
      end
    

    get '/songs' do
        @song = Song.all
        erb :'/songs/index'
    end

    get '/songs/new' do
        @genres = Genre.all
        erb :'/songs/new'
    end



    get '/songs/:slug' do
        
        @song = Song.find_by_slug(params[:slug])
    
        erb :'songs/show'
      end

      get '/songs/:slug/edit' do
        @song = Song.find_by_slug(params[:slug])
        erb :'/songs/edit'
    end

    post '/songs' do
       #binding.pry
       
        @song = Song.create(params['song'])
        @song.artist = Artist.find_or_create_by(:name => params["artist"]["name"])
        @song.genre_ids = params[:genres]
        @song.save
        flash[:message] = "Successfully created song."
        redirect "/songs/#{@song.slug}"
       
    end

    patch '/songs/:slug' do
        @song = Song.find_by_slug(params[:slug])
        @song.update(params[:song])
        @song.artist = Artist.find_or_create_by(:name => params["artist"]["name"])
        @song.save
        flash[:message] = "Successfully updated song."
        redirect "/songs/#{@song.slug}"
    end
end