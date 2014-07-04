ActiveAdmin.register GearCategory do
  permit_params :name

  menu :label => "Gear Categories", :parent => "Equipment"
end
