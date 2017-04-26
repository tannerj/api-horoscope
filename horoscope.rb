require 'dotenv'
Dotenv.load
require 'httparty'
require 'oauth'
require 'sinatra'

get '/' do
  @wiki_title = get_wiki_title
  @prediction = "You will have a day full of #{@wiki_title}."
  erb :index
end

post '/' do
  tweet_prediction( params[:prediction] )
  redirect to("/")
end

def get_wiki_title
  response = HTTParty.get('https://en.wikipedia.org/w/api.php?action=query&list=random&rnlimit=1&rnnamespace=0&format=json')
  body = JSON.parse(response.body)
  body["query"]["random"][0]['title']
end

def tweet_prediction( prediction )
  consumer = OAuth::Consumer.new(
               ENV['API_KEY'], 
               ENV['API_SECRET'],
               { site: 'https://api.twitter.com', scheme: 'header' }
             )
  token_hash = { 
    oauth_token: ENV['ACCESS_TOKEN'], 
    oauth_token_secret: ENV['ACCESS_TOKEN_SECRET'] 
  }
  access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
  access_token.request(
    :post, 
    'https://api.twitter.com/1.1/statuses/update.json', 
    status: prediction
  )
end
