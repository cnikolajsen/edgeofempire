class AdventuresController < InheritedResources::Base
  before_filter :set_up

  def set_up
    @page = 'adventures'
    @title = "Adventures"
  end
  
end
