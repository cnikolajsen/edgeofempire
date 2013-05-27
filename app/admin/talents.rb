ActiveAdmin.register Talent do
  menu :parent => "Careers"

  config.sort_order = "name_asc"

  index do
    column :name
    column :description do |desc|
      #text_replace_tokens(desc.description.gsub("\n", "<br />")).html_safe
      truncate(desc.description)
    end
    column :activation
    default_actions
  end
  
  show do
    div do
      strong "Activation: #{talent.activation}"
    end
    div do
      simple_format text_replace_tokens(talent.description)
    end
  end

  filter :name

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_talents_url }
       end
     end
   end
end
