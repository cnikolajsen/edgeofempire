class CreateStarshipCategories < ActiveRecord::Migration
  def change
    create_table :starship_categories do |t|
      t.string :name

      t.timestamps
    end

    StarshipCategory.create(name: 'Starfighter')
    StarshipCategory.create(name: 'Patrol Boat')
    StarshipCategory.create(name: 'Shuttle')
    StarshipCategory.create(name: 'Transport')
    StarshipCategory.create(name: 'Freighter')
    StarshipCategory.create(name: 'Yacht')
    StarshipCategory.create(name: 'Corvette')
    StarshipCategory.create(name: 'Frigate')
    StarshipCategory.create(name: 'Scout Ship')
    StarshipCategory.create(name: 'Bulk Freighter')
    StarshipCategory.create(name: 'Light Assault Transport')
    StarshipCategory.create(name: 'Bulk Cruiser')
    StarshipCategory.create(name: 'Cruiser')
    StarshipCategory.create(name: 'Small Transport')
    StarshipCategory.create(name: 'Racing Vessel')
    StarshipCategory.create(name: 'Light Cruiser')
    StarshipCategory.create(name: 'Armed Transport')
    StarshipCategory.create(name: 'Heavy Cruiser')
    StarshipCategory.create(name: 'Star Destroyer')
    StarshipCategory.create(name: 'Heavy Star Cruiser')
    StarshipCategory.create(name: 'Heavy Freighter')
    StarshipCategory.create(name: 'Escape Pod')
    StarshipCategory.create(name: 'Droid Operated')
    StarshipCategory.create(name: 'Starliner')
    StarshipCategory.create(name: 'Carrier')
  end
end
