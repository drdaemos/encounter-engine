Rails.application.routes.draw do
  resources :users do
    resources :games
  end

  resources :teams

  resources :invitations

  resources :games do
    resources :levels do
      resources :hints
      resources :questions do
        resources :answers
      end

      member do
        get 'move_up'
        get 'move_down'
      end

    end
  end
 
  get '/play/:game_id/tip', to: 'game_passings#get_current_level_tip', as: :get_current_level_tip
  get '/play/:game_id', to: 'game_passings#show_current_level', as: :show_current_level
  post '/play/:game_id', to: 'game_passings#post_answer', as: :post_answer

#  match('/stats/:game_id', :method => :get).to(:controller => :game_passings, :action => :index).name(:game_stats)
  get '/stats/:action/:game_id', to: 'game_passings#index', as: :game_stats
  get '/logs/livechannel/:game_id', to: 'logs#show_live_channel', as: :show_live_channel # прямой эфир
  get '/logs/level/:game_id/:team_id', to: 'logs#show_level_log', as: :show_level_log # лог по уровню
  get '/logs/game/:game_id/:team_id', to: 'logs#show_game_log', as: :show_game_log # лог по игре
  get '/logs/full/:game_id', to: 'logs#show_full_log', as: :show_full_log # полный лог по игре
  
  get '/game_entries/new/:game_id/:team_id', to: 'game_entries#new', as: :new # отправка заявки
  get '/signup', to: 'users#new', as: :signup
  get '/dashboard', to: 'dashboard#index', as: :dashboard
  get '/team-room', to: 'team_room#index', as: :team_room


  root to: 'index#index', as: :index_page
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
