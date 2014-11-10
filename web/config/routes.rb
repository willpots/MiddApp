MiddMenu::Application.routes.draw do
  get "main/index"
  get "data/fetch"
  root 'main#index'
end
