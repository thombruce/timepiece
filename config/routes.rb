Rails.application.routes.draw do
  match 'timepiece/clock', to: 'timepiece#clock', via: 'post'
end
