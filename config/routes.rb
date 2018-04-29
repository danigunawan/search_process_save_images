Rails.application.routes.draw do
	root 'images#index'

	resources :images do
		get 'download_file'
	end
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
