require 'test_helper'

class VehicleWeaponsControllerTest < ActionController::TestCase
  setup do
    @vehicle_weapon = vehicle_weapons(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vehicle_weapons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vehicle_weapon" do
    assert_difference('VehicleWeapon.count') do
      post :create, vehicle_weapon: { critical: @vehicle_weapon.critical, damage: @vehicle_weapon.damage, name: @vehicle_weapon.name, price: @vehicle_weapon.price, range: @vehicle_weapon.range, rarity: @vehicle_weapon.rarity, size_high: @vehicle_weapon.size_high, size_low: @vehicle_weapon.size_low, slug: @vehicle_weapon.slug }
    end

    assert_redirected_to vehicle_weapon_path(assigns(:vehicle_weapon))
  end

  test "should show vehicle_weapon" do
    get :show, id: @vehicle_weapon
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vehicle_weapon
    assert_response :success
  end

  test "should update vehicle_weapon" do
    patch :update, id: @vehicle_weapon, vehicle_weapon: { critical: @vehicle_weapon.critical, damage: @vehicle_weapon.damage, name: @vehicle_weapon.name, price: @vehicle_weapon.price, range: @vehicle_weapon.range, rarity: @vehicle_weapon.rarity, size_high: @vehicle_weapon.size_high, size_low: @vehicle_weapon.size_low, slug: @vehicle_weapon.slug }
    assert_redirected_to vehicle_weapon_path(assigns(:vehicle_weapon))
  end

  test "should destroy vehicle_weapon" do
    assert_difference('VehicleWeapon.count', -1) do
      delete :destroy, id: @vehicle_weapon
    end

    assert_redirected_to vehicle_weapons_path
  end
end
