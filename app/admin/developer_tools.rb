ActiveAdmin.register_page "Developer Tools" do

  page_action :reset_character_items, :method => :post do
    CharacterWeapon.destroy_all
    CharacterGear.destroy_all
    CharacterArmor.destroy_all
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE character_weapons RESTART IDENTITY;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE character_gears RESTART IDENTITY;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE character_armors RESTART IDENTITY;")
    redirect_to admin_developer_tools_path, :notice => "Character equipment for all characters have been reset."
  end

  page_action :delete_characters, :method => :post do
    Character.destroy_all
    CharacterObligation.destroy_all
    CharacterExperienceCost.destroy_all
    CharacterSkill.destroy_all
    CharacterStartingSkillRank.destroy_all
    CharacterTalent.destroy_all
    CharacterBonusTalent.destroy_all
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE character_talents RESTART IDENTITY;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE character_bonus_talents RESTART IDENTITY;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE character_skills RESTART IDENTITY;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE character_starting_skill_ranks RESTART IDENTITY;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE characters RESTART IDENTITY;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE character_obligations RESTART IDENTITY;")
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE character_experience_costs RESTART IDENTITY;")
    redirect_to admin_developer_tools_path, :notice => "All player characters have been deleted. U Cry Now?"
  end

  page_action :toggle_armor_attachment, :method => :post do
    check = ArmorAttachmentsArmor.where(:armor_id => params[:armor], :armor_attachment_id => params[:attachment]).first
    if check
      check.delete
    else
      ArmorAttachmentsArmor.where(:armor_id => params[:armor], :armor_attachment_id => params[:attachment]).create
    end
    respond_to do |format|
      format.js  {}
    end
  end

  page_action :toggle_weapon_attachment, :method => :post do
    check = WeaponAttachmentsWeapon.where(:weapon_id => params[:weapon], :weapon_attachment_id => params[:attachment]).first
    if check
      check.delete
    else
      WeaponAttachmentsWeapon.where(:weapon_id => params[:weapon], :weapon_attachment_id => params[:attachment]).create
    end
    respond_to do |format|
      format.js  {}
    end
  end

  #page_action :toggle_armor_attachment_group, :method => :post do
  #  check = ArmorAttachmentsGroup.where(:armor_id => params[:armor], :attachment_group_id => params[:group]).first
  #  if check
  #    check.destroy
  #  else
  #    ArmorAttachmentsGroup.where(:armor_id => params[:armor], :attachment_group_id => params[:group]).create
  #  end
  #  respond_to do |format|
  #    format.js  {}
  #  end
  #end
#
  #page_action :toggle_weapon_attachment_group, :method => :post do
  #  check = WeaponAttachmentsGroup.where(:weapon_id => params[:weapon], :attachment_group_id => params[:group]).first
  #  if check
  #    check.destroy
  #  else
  #    WeaponAttachmentsGroup.where(:weapon_id => params[:weapon], :attachment_group_id => params[:group]).create
  #  end
  #  respond_to do |format|
  #    format.js  {}
  #  end
  #end
#
  #page_action :toggle_armor_attachment_attachment_group, :method => :post do
  #  check = ArmorAttachmentAttachmentsGroup.where(:armor_attachment_id => params[:attachment], :attachment_group_id => params[:group]).first
  #  if check
  #    check.destroy
  #  else
  #    ArmorAttachmentAttachmentsGroup.where(:armor_attachment_id => params[:attachment], :attachment_group_id => params[:group]).create
  #  end
  #  respond_to do |format|
  #    format.js  {}
  #  end
  #end
#
  #page_action :toggle_weapon_attachment_attachment_group, :method => :post do
  #  check = WeaponAttachmentAttachmentsGroup.where(:weapon_attachment_id => params[:attachment], :attachment_group_id => params[:group]).first
  #  if check
  #    check.destroy
  #  else
  #    WeaponAttachmentAttachmentsGroup.where(:weapon_attachment_id => params[:attachment], :attachment_group_id => params[:group]).create
  #  end
  #  respond_to do |format|
  #    format.js  {}
  #  end
  #end

  action_item do
    link_to "Delete all characters", admin_developer_tools_delete_characters_path, :method => :post, :confirm => "Are you sure? This will delete all characters in the database. No refunds!"
  end
  action_item do
    link_to "Reset character equipment", admin_developer_tools_reset_character_items_path, :method => :post
  end

  content do
    #para "Be very careful with the functions on this page. They can not be undone."
    #panel "Character Talents" do
    #  table :class => "index_table" do
    #    CharacterTalent.all.order("character_id ASC").map do |talent|
    #      tr :class => cycle("odd", "even") do
    #        td talent.inspect
    #      end
    #    end
    #  end
    #end

    #panel "Character Skills" do
    #  table :class => "index_table" do
    #    CharacterSkill.all.order("character_id ASC").map do |talent|
    #      tr :class => cycle("odd", "even") do
    #        td talent.inspect
    #      end
    #    end
    #  end
    #end

    panel "Armor attachments" do
      div :id => "allowed_armor_attachments" do
        render "armor_attachments"
      end
    end

    panel "Weapon attachments" do
      div :id => "allowed_weapon_attachments" do
        render "weapon_attachments"
      end
    end

    #panel "Armor - Attachment groups" do
    #  div :id => "armor_attachment_groups" do
    #    render "armor_attachment_groups"
    #  end
    #end
#
    #panel "Weapon - Attachment groups" do
    #  div :id => "weapon_attachment_groups" do
    #    render "weapon_attachment_groups"
    #  end
    #end
#
    #panel "Armor Attachment - Attachment groups" do
    #  div :id => "armor_attachment_attachment_groups" do
    #    render "armor_attachment_attachment_groups"
    #  end
    #end
#
    #panel "Weapon Attachment - Attachment groups" do
    #  div :id => "weapon_attachment_attachment_groups" do
    #    render "weapon_attachment_attachment_groups"
    #  end
    #end

  end
end