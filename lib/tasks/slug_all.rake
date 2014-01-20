namespace :slug_all do
  desc "Generate slugs for all armors"
  task armor: :environment do
    Armor.find_each(&:save)
  end

  desc "Generate slugs for all gear"
  task gear: :environment do
    Gear.find_each(&:save)
  end

  desc "Generate slugs for all weapons"
  task weapon: :environment do
    Weapon.find_each(&:save)
  end

  desc "Generate slugs for all skills"
  task skill: :environment do
    Skill.find_each(&:save)
  end

  desc "Generate slugs for all careers"
  task career: :environment do
    Career.find_each(&:save)
  end

  desc "Generate slugs for all races"
  task race: :environment do
    Race.find_each(&:save)
  end

  desc "Generate slugs for all talent trees"
  task talent_tree: :environment do
    TalentTree.find_each(&:save)
  end

  desc "Generate slugs for all users"
  task user: :environment do
    User.find_each(&:save)
  end
end
