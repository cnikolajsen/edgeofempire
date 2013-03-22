class CampaignsController < InheritedResources::Base
  before_filter :set_up
  
  def create
    @campaign = Campaign.new(params[:campaign])
    @campaign.user_id = current_user.id
    
    respond_to do |format|
      if @campaign.save
        format.html { redirect_to @campaign, notice: 'Campaign was successfully created.' }
        format.json { render json: @campaign, status: :created, location: @campaign }
      else
        format.html { render action: "new" }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  def set_up
    @page = 'campaigns'
    @title = "Campaigns"
  end
  
end
