ActiveAdmin.register WeaponCategory do
  permit_params :name

  menu false

  action_item do
    link_to "Weapons", admin_weapons_path
  end

end
