class AdventuresController < InheritedResources::Base
  before_filter :set_up

  def set_up
    @page = 'adventures'
    @title = "Adventures"
  end

private
  def adventure_params
    params.require(:adventure).permit( :campaign_id, :description, :name )
  end

  
end
