class PagesController < ApplicationController

  def increasing
    pages = Page.where("difference > 0")
    render json: pages
  end

end
