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

    member do
      get 'end_game'
      get 'start_test'
      get 'finish_test'
    end
  end
 
  get '/play/:game_id/tip', to: 'game_passings#get_current_level_tip', as: :get_current_level_tip
  get '/play/:game_id', to: 'game_passings#show_current_level', as: :show_current_level
  post '/play/:game_id', to: 'game_passings#post_answer', as: :post_answer
  post '/play/:game_id/exit_game', to: 'game_passings#exit_game', as: :exit_game

#  match('/stats/:game_id', :method => :get).to(:controller => :game_passings, :action => :index).name(:game_stats)
  get '/ratings', to: 'ratings#index', as: :ratings
  get '/stats/:action/:game_id', to: 'game_passings#index', as: :game_stats
  get '/logs/livechannel/:game_id', to: 'logs#show_live_channel', as: :show_live_channel # прямой эфир
  get '/logs/level/:game_id/:team_id', to: 'logs#show_level_log', as: :show_level_log # лог по уровню
  get '/logs/game/:game_id/:team_id', to: 'logs#show_game_log', as: :show_game_log # лог по игре
  get '/logs/full/:game_id', to: 'logs#show_full_log', as: :show_full_log # полный лог по игре
  
  get '/game_entries/new/:game_id/:team_id', to: 'game_entries#new', as: :new_game_entry # отправка заявки
  get '/game_entries/recall/:id', to: 'game_entries#recall', as: :recall_game_entry # отзыв заявки
  get '/game_entries/cancel/:id', to: 'game_entries#cancel', as: :cancel_game_entry # отмен заявки
  get '/game_entries/reopen/:id', to: 'game_entries#reopen', as: :reopen_game_entry # заново заявка
  get '/game_entries/accept/:id', to: 'game_entries#accept', as: :accept_game_entry # заявка принята
  get '/game_entries/reject/:id', to: 'game_entries#reject', as: :reject_game_entry # заявка отказана

  get '/dashboard', to: 'dashboard#index', as: :dashboard
  get '/send_msg', to: 'dashboard#send_msg', as: :send_msg
  get '/team-room', to: 'team_room#index', as: :team_room
  get '/game-results', to: 'games#results', as: :game_results
  get '/settings', to: 'settings#index', as: :settings
  post '/settings/update', to: 'settings#update', as: :update_settings

  root to: 'index#index', as: :index_page
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
