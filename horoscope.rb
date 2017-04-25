require 'dotenv'
Dotenv.load
require 'httparty'
require 'oauth'
require 'sinatra'

get '/' do
  @prediction = ['🍰', '💔', '💪', '🏆', '🐷', '🍕', '🤖'].sample
  @wiki_title = get_wiki_title
  @fortune = twitter_prediction( @wiki_title )
  erb :index
end

def get_wiki_title
  response = HTTParty.get('https://en.wikipedia.org/w/api.php?action=query&list=random&rnlimit=1&rnnamespace=0&format=json')
  body = JSON.parse(response.body)
  body["query"]["random"][0]['title']
end

def twitter_prediction(wiki_title)
  "You will have a day full of #{@wiki_title}."
end
