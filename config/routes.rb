Rails.application.routes.draw do
  namespace :api do
    namespace :payments do
      get :in_month
    end
    namespace :bonus do
      get :streak
    end
  end
end
