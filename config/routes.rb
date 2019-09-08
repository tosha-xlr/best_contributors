Rails.application.routes.draw do
  root 'awords#index'

  get 'aword' => 'awords#aword'
  get 'awords' => 'awords#awords'
  post 'awords' => 'awords#awords'
end
