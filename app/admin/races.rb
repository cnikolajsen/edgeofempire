ActiveAdmin.register Race do
  permit_params :agility, :brawn, :cunning, :description, :intellect, :name, :presence, :special_ability, :starting_experience, :strain_threshold, :willpower, :wound_threshold
  
  config.sort_order = "name_asc"

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_races_url }
       end
     end
   end
end
