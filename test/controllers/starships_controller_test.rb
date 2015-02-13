require 'test_helper'

class StarshipsControllerTest < ActionController::TestCase
  setup do
    @starship = starships(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:starships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create starship" do
    assert_difference('Starship.count') do
      post :create, starship: { armor: @starship.armor, book_id: @starship.book_id, consumables: @starship.consumables, cost: @starship.cost, defense_aft: @starship.defense_aft, defense_fore: @starship.defense_fore, defense_port: @starship.defense_port, defense_starboard: @starship.defense_starboard, description: @starship.description, encumbrance_capacity: @starship.encumbrance_capacity, handling: @starship.handling, hard_points: @starship.hard_points, hull_trauma_threshold: @starship.hull_trauma_threshold, hull_type: @starship.hull_type, hyperdrive_class_primary: @starship.hyperdrive_class_primary, hyperdrive_class_secondary: @starship.hyperdrive_class_secondary, manufacturer: @starship.manufacturer, name: @starship.name, navicomputer: @starship.navicomputer, passenger_capacity: @starship.passenger_capacity, rarity: @starship.rarity, sensor_range: @starship.sensor_range, silhouette: @starship.silhouette, speed: @starship.speed, starship_category_id: @starship.starship_category_id, system_strain_threshold: @starship.system_strain_threshold }
    end

    assert_redirected_to starship_path(assigns(:starship))
  end

  test "should show starship" do
    get :show, id: @starship
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @starship
    assert_response :success
  end

  test "should update starship" do
    patch :update, id: @starship, starship: { armor: @starship.armor, book_id: @starship.book_id, consumables: @starship.consumables, cost: @starship.cost, defense_aft: @starship.defense_aft, defense_fore: @starship.defense_fore, defense_port: @starship.defense_port, defense_starboard: @starship.defense_starboard, description: @starship.description, encumbrance_capacity: @starship.encumbrance_capacity, handling: @starship.handling, hard_points: @starship.hard_points, hull_trauma_threshold: @starship.hull_trauma_threshold, hull_type: @starship.hull_type, hyperdrive_class_primary: @starship.hyperdrive_class_primary, hyperdrive_class_secondary: @starship.hyperdrive_class_secondary, manufacturer: @starship.manufacturer, name: @starship.name, navicomputer: @starship.navicomputer, passenger_capacity: @starship.passenger_capacity, rarity: @starship.rarity, sensor_range: @starship.sensor_range, silhouette: @starship.silhouette, speed: @starship.speed, starship_category_id: @starship.starship_category_id, system_strain_threshold: @starship.system_strain_threshold }
    assert_redirected_to starship_path(assigns(:starship))
  end

  test "should destroy starship" do
    assert_difference('Starship.count', -1) do
      delete :destroy, id: @starship
    end

    assert_redirected_to starships_path
  end
end
