class CommunitiesController < ApplicationController

	# ...

	def show 
		@community = Community.find(params[:id])
		@users = @community.users
		@ressources = Ressource.paginate(:page => params[:page], :per_page => 5)
	end


	# ...
end
