ActiveAdmin.register Skill do
  form do |f|                         
    f.inputs "Skill Details" do       
      f.input :name                  
      f.input :description
      f.input :characteristic, :as => :select, :collection => ['Agility', 'Brawn', 'Cunning', 'Intellect', 'Presence', 'Willpower']
    end                               
    f.actions                         
  end  
end
