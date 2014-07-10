ActiveAdmin.register ArmorCategory do
  permit_params :name

  menu false

  action_item do
    link_to "Armor", admin_armors_path
  end

end
