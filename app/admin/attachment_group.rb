ActiveAdmin.register AttachmentGroup do
  permit_params :name

  #menu :label => "Attachment Groups", :parent => "Equipment"
  menu false

  config.sort_order = "name_asc"
  config.per_page = 50

  filter :name

  form do |f|
    f.inputs "Attachment Group Details" do
      f.input :name
    end
    f.actions
  end

  controller do
    def create
      create! do |format|
        format.html { redirect_to new_admin_attachment_group_url }
      end
    end
  end

end
