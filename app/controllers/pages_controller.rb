class PagesController < ApplicationController

  def home
    @page = 'home'
    @title = "Edge of the Empire Dummy Frontpage"
  end

end
