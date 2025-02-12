Rails.application.routes.draw do

  get 'welcome/index'
  # AUTHENTICATION ENDPOINTS
  resource :session, controller: 'sessions', only: [:create, :destroy], defaults: {format: :json}
  resource :registration, controller: 'registrations', only: [:create], defaults: {format: :json}
  resource :registration, controller: 'rails_jwt_auth/registrations', only: [:create, :update, :destroy]
  resource :password, controller: 'rails_jwt_auth/passwords', only: [:create, :update]
  resource :confirmation, controller: 'rails_jwt_auth/confirmations', only: [:create]
  resource :confirmation, controller: 'confirmations', only: [:update]

  # USER ENDPOINTS
  resources :users, defaults: {format: :json}, only: [:show, :update, :destroy]
  post '/feedback', to: 'feedback#create', defaults: {format: :json}

  # PROJECT ENDPOINTS
  put '/projects/:id/filter', to: 'filter#show', defaults: {format: :json}
  get '/projects/:id/export/:format', to: 'export#show', defaults: {format: :json}
  get '/projects/:id/clone', to: 'projects#clone', defaults: {format: :json}
  put '/projects/import', to: 'import#index', defaults: {format: :json}
  post '/projects/:id/manifests', to: 'projects#createManifest', defaults: {format: :json}
  put '/projects/:id/manifests', to: 'projects#updateManifest', defaults: {format: :json}
  delete '/projects/:id/manifests', to: 'projects#deleteManifest', defaults: {format: :json}
  get '/projects/:id/viewOnly', to: 'projects#viewOnly', defaults: {format: :json}
  resources :projects, defaults: {format: :json}, only: [:index, :show, :update, :destroy, :create]

  # XPROC endpoints
  get '/transformations/zip/:job_id', to: 'xproc#get_zip', defaults: { format: :json }

  # DIY IMAGE ENDPOINTS
  post '/images', to: 'images#uploadImages', defaults: {format: :json}
  put '/images/link', to: 'images#link', defaults: {format: :json}
  put '/images/unlink', to: 'images#unlink', defaults: {format: :json}
  get '/images/:imageID_filename', to: 'images#show', defaults: {format: :json}
  get '/images/zip/:id', to: 'images#getZipImages', defaults: {format: :json}
  delete '/images', to: 'images#destroy', defaults: {format: :json}

  # GROUP ENDPOINTS
  resources :groups, defaults: {format: :json}, only: [:update, :destroy, :create]
  put '/groups', to: 'groups#updateMultiple', defaults: {format: :json}, only: [:update]
  delete '/groups', to: 'groups#destroyMultiple', defaults: {format: :json}, only: [:destroy]

  # LEAF ENDPOINTS
  put '/leafs/generateFolio', to: 'leafs#generateFolio', defaults: {format: :json}, only: [:update]
  put '/leafs/conjoin', to: 'leafs#conjoinLeafs', defaults: {format: :json}, only: [:update]
  put '/leafs', to: 'leafs#updateMultiple', defaults: {format: :json}, only: [:update]
  delete '/leafs', to: 'leafs#destroyMultiple', defaults: {format: :json}, only: [:destroy]
  resources :leafs, defaults: {format: :json}, only: [:update, :destroy, :create]

  # SIDE ENDPOINTS
  put '/sides/generatePageNumber', to: 'sides#generatePageNumber', defaults: {format: :json}, only: [:update]
  put '/sides/:id', to: 'sides#update', defaults: {format: :json}, only: [:update]
  put '/sides', to: 'sides#updateMultiple', defaults: {format: :json}, only: [:update]

  # TERM ENDPOINTS
  put '/terms/:id/link', to: 'terms#link', defaults: {format: :json}, only: [:update]
  put '/terms/:id/unlink', to: 'terms#unlink', defaults: {format: :json}, only: [:update]
  post '/terms/taxonomy', to: 'terms#createTaxonomy', defaults: {format: :json}, only: [:create]
  put '/terms/taxonomy', to: 'terms#updateTaxonomy', defaults: {format: :json}, only: [:update]
  delete '/terms/taxonomy', to: 'terms#deleteTaxonomy', defaults: {format: :json}, only: [:destroy]
  resources :terms, defaults: {format: :json}, only: [:show, :update, :destroy, :create]

  # DOCUMENTATION
  get '/docs' => redirect('/docs/index.html')

  # Add a healthcheck route for api online/offline polling
  get '/status', to: proc { [200, {}, ['']] }

  ##
  # We need to route other calls to static index so that in production/staging
  # Rails will send the '/index.html' generated by npm build.
  # This isn't ideal, but attempts to render the HTML by mapping '/', simply
  # haven't work -- rails keeps trying to interpret 'public/index.html' as route.
  # This method is used in combination with RAILS_SERVE_STATIC_FILES so that
  # browsers can request the React/etc. JS files in 'public/static/js'
  # TODO: look into a reverse proxy to serve static files (nginx?)
  get '*other', to: 'static#index'

end
