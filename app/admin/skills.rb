ActiveAdmin.register Skill do
  menu :parent => "Careers"
  
  config.sort_order = "name_asc"
  config.per_page = 10
  
  filter :name
  filter :description
  filter :characteristic, :as => :select, :collection => ['Agility', 'Brawn', 'Cunning', 'Intellect', 'Presence', 'Willpower']
  
  index do                            
    column :name                     
    column :description        
    column :characteristic           
    default_actions                   
  end
  
  form do |f|                         
    f.inputs "Skill Details" do       
      f.input :name                  
      f.input :description
      f.input :characteristic, :as => :select, :collection => ['Agility', 'Brawn', 'Cunning', 'Intellect', 'Presence', 'Willpower']
    end                               
    f.actions                         
  end  

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_skills_url }
       end
     end
   end
end
