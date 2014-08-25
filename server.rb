require 'sinatra'
require 'pry'
require 'sinatra/reloader'
def take_scores
score_array = [
    {
      home_team: "Patriots",
      away_team: "Broncos",
      home_score: 7,
      away_score: 3,
    },
    {
      home_team: "Broncos",
      away_team: "Colts",
      home_score: 3,
      away_score: 0,
    },
    {
      home_team: "Patriots",
      away_team: "Colts",
      home_score: 11,
      away_score: 7,
    },
    {
      home_team: "Steelers",
      away_team: "Patriots",
      home_score: 7,
      away_score: 21,
    }
  ]
end
def pull_teams(raw_results)
  teams = Hash.new 0
  raw_results.each do |game|
    teams.merge!(game[:home_team] => {wins: 0, losses: 0})
    teams.merge!(game[:away_team] => {wins: 0, losses: 0})
  end
  raw_results.each do |game|
    if game[:home_score] > game[:away_score]
      teams[game[:home_team]][:wins] += 1
      teams[game[:away_team]][:losses] += 1
    else
      teams[game[:away_team]][:wins] += 1
      teams[game[:home_team]][:losses] += 1
    end
  end
  teams
end
def determine_ranking(teams)
  teams = teams.sort_by{|k,v| v[:wins]}.reverse
end
teams = Hash.new 0


get '/' do
  @raw_results = take_scores
  @teams = pull_teams(@raw_results)
  erb :index
end

get '/leaderboards/' do
  @raw_results = take_scores
  @teams = pull_teams(@raw_results)
  @sorted = determine_ranking(@teams)
  erb :leaderboards
end

get '/teams/:team' do
  @team = params[:team]
  @raw_results = take_scores
  @teams = pull_teams(@raw_results)

  @wins = @teams[@team][:wins]
  @losses = @teams[@team][:losses]

  @games = @raw_results.find_all do |k,v|
    k[:home_team] == @team || k[:away_team] == @team
  end

  erb :teams
end
