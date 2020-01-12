class TweetsController < ApplicationController

  get '/tweets' do
    if Helper.is_logged_in?(session)
      @tweets = Tweet.all
      erb :'/tweets/tweets'
    else
      redirect '/users/login'
    end
  end
  
  get '/tweets/new' do 
    user = Helper.current_user(session)
    if user.nil?
      redirect '/login'
    else
      erb :'/tweets/new'
    end
  end
  
  post '/tweets' do 
    user = Helper.current_user(session)
    if user.nil?
      redirect to '/login'
    elsif params[:tweet][:content].empty?
      redirect '/tweets/new'
    else
      user.tweets.build({content: params[:tweet][:content]})
      user.save
    end
    redirect '/tweets'
  end
  
  get '/tweets/:id/delete' do
    if Helper.is_logged_in?(session)
      @tweet = Tweet.find(params[:id])
      if @tweet.user == Helper.current_user(session)
        @tweet = Tweet.find_by_id(params[:id])
        @tweet.delete
        redirect '/tweets'
      else
        redirect '/tweets'
      end
    else
      redirect '/login'
    end
  end
  
  get '/tweets/:id/edit' do
    if Helper.is_logged_in?(session)
      @tweet = Tweet.find_by_id(params[:id])
      if @tweet.user == Helper.current_user(session)
          erb :'/tweets/edit'
      else
        redirect '/login'
      end
    else
      redirect '/login'
    end
  end
  
  patch '/tweets/:id' do 
    @tweet = Tweet.find_by_id(params[:id])

    if params[:tweet][:content].empty?
      redirect "/tweets/#{@tweet.id}/edit"
    end

    @tweet.update(params[:tweet])
    @tweet.save
    redirect "/tweets/#{@tweet.id}"
  end
  
  get '/tweets/:id' do 
    redirect '/login' unless Helper.is_logged_in?(session)
    @tweet = Tweet.find_by_id(params[:id])
    erb :"tweets/show"
  end
  
  
end





