ActiveAdmin.register Career do
  index do                            
    column :name                     
    column :description                     
    default_actions                   
  end
  
  config.sort_order = "name_asc"
  
  config.filters = false
end
