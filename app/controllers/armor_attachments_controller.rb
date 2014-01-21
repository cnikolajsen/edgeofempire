class ArmorAttachmentsController < ApplicationController
  before_filter :set_up

  def index
    @attachments = ArmorAttachment.where(:true).order(:name)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @attachments }
    end
  end

  def set_up
    @page = 'armor_attachments'
    @title = "Armor Attachments"
  end

end