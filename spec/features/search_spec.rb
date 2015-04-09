require 'spec_helper.rb'

feature "Looking up recipes", js: true do
  before do
    FactoryGirl.create(:recipe, name: 'Baked Potato w/ Cheese')
    FactoryGirl.create(:recipe, name: 'Garlic Mashed Potatoes')
    FactoryGirl.create(:recipe, name: 'Potatoes Au Gratin')
    FactoryGirl.create(:recipe, name: 'Baked Brussel Sprouts')
  end

  scenario "finding recipes" do
    visit '/'
    fill_in "keywords", with: "baked"
    click_on "Search"

    expect(page).to have_content("Baked Potato")
    expect(page).to have_content("Baked Brussel Sprouts")
  end
end