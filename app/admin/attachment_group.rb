ActiveAdmin.register AttachmentGroup do
  permit_params :name

  menu :label => "Attachment Groups", :parent => "Equipment"

  config.sort_order = "name_asc"
  config.per_page = 50

  filter :name
  #filter :weapon
  #filter :armor

  controller do
    def create
      create! do |format|
        format.html { redirect_to new_admin_attachment_group_url }
      end
    end
  end

end
