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

  sidebar :help do
    ul do
      li "Developer Tools" do
        ul do
          li link_to "Reset character equipment", admin_developer_tools_reset_character_items_path, :method => :post
          li link_to "Delete all characters", admin_developer_tools_delete_characters_path, :method => :post, :confirm => "Are you sure? This will delete all characters in the database. No refunds!"
        end
      end

    end
  end

  content do
    para "Be very careful with the functions on this page. They can not be undone."
    panel "Character Talents" do
      table :class => "index_table" do
        CharacterTalent.all.order("character_id ASC").map do |talent|
          tr :class => cycle("odd", "even") do
            td talent.inspect
          end
        end
      end
    end

    panel "Character Skills" do
      table :class => "index_table" do
        CharacterSkill.all.order("character_id ASC").map do |talent|
          tr :class => cycle("odd", "even") do
            td talent.inspect
          end
        end
      end
    end
  end
end