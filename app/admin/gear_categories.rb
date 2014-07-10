ActiveAdmin.register GearCategory do
  permit_params :name

  menu false

  action_item do
    link_to "Gear", admin_gears_path
  end

end
