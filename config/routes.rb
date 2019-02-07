Rails.application.routes.draw do
  post '/line_me', to: 'line_me#messaging_api'

  resources :responses, only: [:index]
  post '/responses', to: 'responses#index'
  delete '/responses', to: 'responses#index'
end
