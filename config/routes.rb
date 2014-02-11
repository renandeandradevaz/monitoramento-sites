MonitoramentoSites::Application.routes.draw do

  root 'sites#index'

  resources :sites

end
