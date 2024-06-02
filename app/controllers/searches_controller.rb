class SearchesController < ApplicationController
  before_action :authenticate_user!
  　#6/2検索のコントローラに３つの変数を実装する
	def search
		@model = params[:model]
		@content = params[:content]
		@method = params[:method]
		if @model == 'user'
			@records = User.search_for(@content, @method)
		else
			@records = Book.search_for(@content, @method)
		end
	end
end
