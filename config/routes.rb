MonitoramentoSites::Application.routes.draw do

  root 'sites#index'

  get "sites/verifica_atualizacao"

  resources :sites do
    member do
      get :marcar_como_visto
    end
  end

  resources :sites

end
