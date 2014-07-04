ActiveAdmin.register ArmorCategory do
  permit_params :name

  menu :label => "Armor Categories", :parent => "Equipment"
end
