class SearchController < ApplicationController
  skip_authorization_check only: :index

  def index
    return @results = [] if params[:query].blank?

    @results = SearchService.call(params[:query], params[:scope])
  end
end
