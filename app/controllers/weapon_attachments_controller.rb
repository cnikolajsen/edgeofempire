class WeaponAttachmentsController < ApplicationController
  before_filter :set_up

  def index
    @attachments = WeaponAttachment.where(:true).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @attachments }
    end
  end

  def set_up
    @page = 'weapon_attachments'
    @title = "Weapon Attachments"
  end

end