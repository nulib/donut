Rails.application.routes.draw do
  resources :batches, only: [:index, :show]
  get '/batches/detail/:accession_number',
      to: 'batches#detail',
      as: :batch_item,
      format: false,
      constraints: { accession_number: /.+/ }

  post '/validate_new', to: 'validation#validate_new', as: :validate_new
  patch '/validate_edit', to: 'validation#validate_edit', as: :validate_edit

  mount BrowseEverything::Engine => '/browse'
  mount Blacklight::Engine => '/'

  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users, skip: [:sessions], controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, format: false
  devise_scope :user do
    get '/users/sign_in', to: 'users/sessions#new', as: :new_user_session
    delete '/users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
    match '/users/auth/:provider', to: 'users/omniauth_callbacks#user', as: :user_omniauth_authorize, via: [:get, :post]
    match '/users/auth/openam/callback', controller: 'users/omniauth_callbacks', as: :user_omniauth_callback, via: [:get, :post]
  end
  mount Hydra::RoleManagement::Engine => '/'
  mount Qa::Engine => '/authorities'
  mount Hyrax::Engine, at: '/'
  resources :welcome, only: 'index'
  root 'hyrax/homepage#index'
  curation_concerns_basic_routes
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  get '/public/:id-manifest.json', to: 'manifest#public_manifest', as: :public_manifest, constraints: { id: %r{[0-9a-zA-Z/-]+} }

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end

  post '/publicize_images/:id', to: 'visibility#make_public', as: :publicize_images
end
