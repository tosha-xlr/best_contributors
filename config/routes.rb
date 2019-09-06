Rails.application.routes.draw do
  root 'awords#index'

  get 'awords' => 'awords#awords'
  get 'aword' => 'awords#pdf'
end
