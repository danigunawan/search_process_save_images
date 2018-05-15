Rails.application.routes.draw do
	root 'images#index'

	resources :images do
		get 'download_file'
		get 'search_word_results'
		get 'search_image_png'
	end
	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
