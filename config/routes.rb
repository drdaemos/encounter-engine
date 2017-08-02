Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do 
    get '/signup', to: 'devise/registrations#new', as: :signup
    get '/login', to: 'devise/sessions#new', as: :login
    get '/logout', to: 'devise/sessions#destroy', as: :logout
  end

  resources :users, :only => [:index, :show] do
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
  
  get '/game_entries/new/:game_id/:team_id', to: 'game_entries#new', as: :new_game_entry # отправка заявки
  get '/game_entries/recall/:id', to: 'game_entries#recall', as: :recall_game_entry # отзыв заявки
  get '/game_entries/cancel/:id', to: 'game_entries#cancel', as: :cancel_game_entry # отмен заявки
  get '/game_entries/reopen/:id', to: 'game_entries#reopen', as: :reopen_game_entry # отмен заявки

  get '/dashboard', to: 'dashboard#index', as: :dashboard
  get '/team-room', to: 'team_room#index', as: :team_room


  root to: 'index#index', as: :index_page
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
