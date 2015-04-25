require 'spec_helper'

describe RecipesController do
  render_views

  describe "index" do
    before do
      FactoryGirl.create(:recipe, name: 'Baked Potato w/ Cheese')
      FactoryGirl.create(:recipe, name: 'Garlic Mashed Potatoes')
      FactoryGirl.create(:recipe, name: 'Potatoes Au Gratin')
      FactoryGirl.create(:recipe, name: 'Baked Brussel Sprouts')

      xhr :get, :index, format: :json, keywords: keywords
    end

    subject(:results) { JSON.parse(response.body) }

    def extract_name
      ->(object) { object["name"] }
    end

    context "when the search finds results" do
      let(:keywords) { 'baked' }

      it 'should 200' do
        expect(response.status).to eq(200)
      end
      it 'should return two results' do
        expect(results.size).to eq(2)
      end
      it "should include 'Baked Potato w/ Cheese'" do
        expect(results.map(&extract_name)).to include('Baked Potato w/ Cheese')
      end
      it "should include 'Baked Brussel Sprouts'" do
        expect(results.map(&extract_name)).to include('Baked Brussel Sprouts')
      end
    end

    context "when the search doesn't find results" do
      let(:keywords) { 'foo' }

      it 'should return no results' do
        expect(results.size).to eq(0)
      end
    end
  end

  describe "show" do
    before do
      xhr :get, :show, format: :json, id: recipe_id
    end

    subject(:results) { JSON.parse(response.body) }

    context "when recipe exists" do
      let(:recipe)    { FactoryGirl.create(:recipe) }
      let(:recipe_id) { recipe.id }

      it { expect(response.status).to eq 200 }
      it { expect(results["id"]).to eq recipe_id }
      it { expect(results["name"]).to eq recipe.name }
      it { expect(results["instructions"]).to eq recipe.instructions }
    end

    context "when recipe does not exist" do
      let(:recipe_id) { "any-id" }

      it { expect(response.status).to eq 404 }
    end
  end

  describe 'create' do
    context 'successfully' do
      it 'returns status 201' do
        xhr :post, :create, format: :json, recipe: { name: 'Recipe Name', instructions: 'Recipe Instructions' }
        expect(response.status).to eq(201)
      end

      it 'creates a new recipe' do
        expect { xhr :post, :create, format: :json, recipe: { name: 'Recipe Name', instructions: 'Recipe Instructions' } }.to change{ Recipe.count }.by(1)
      end

      it 'creates recipe with correct attributes' do
        xhr :post, :create, format: :json, recipe: { name: 'Recipe Name', instructions: 'Recipe Instructions' }
        expect(Recipe.last.name).to eq("Recipe Name")
        expect(Recipe.last.instructions).to eq("Recipe Instructions")
      end
    end

    context 'failure' do
      it 'returns status 422' do
        xhr :post, :create, format: :json, recipe: { name: '', instructions: 'Recipe Instructions' }
        expect(response.status).to eq(422)
      end

      it 'does not create a new recipe' do
        expect { xhr :post, :create, format: :json, recipe: { name: '', instructions: 'Recipe Instructions' } }.to_not change{ Recipe.count }
      end
    end
  end

  describe 'update' do
    let(:recipe) { FactoryGirl.create(:recipe, name: 'Recipe name', instructions: 'recipe instructions') }

    context 'successfully' do
      it 'returns status 204' do
        xhr :put, :update, format: :json, id: recipe.id, recipe: { name: 'New Name', instructions: 'new instructions' }
        expect(response.status).to eq(204)
      end

      it 'updates recipe infos' do
        expect { xhr :put, :update, format: :json, id: recipe.id, recipe: { name: 'New Name', instructions: 'new instructions' } }.to change{ recipe.reload.name }.from('Recipe name').to('New Name')
      end
    end

    context 'failure' do
      it 'returns status 422' do
        xhr :put, :update, format: :json, id: recipe.id, recipe: { name: '', instructions: 'new instructions' }
        expect(response.status).to eq(422)
      end

      it 'does not update recipe infos' do
        expect { xhr :put, :update, format: :json, id: recipe.id, recipe: { name: '', instructions: 'new instructions' } }.to_not change{ recipe.reload.name }
      end
    end
  end

  describe 'destroy' do
    let(:recipe_id) { FactoryGirl.create(:recipe).id }

    before do
      xhr :delete, :destroy, format: :json, id: recipe_id
    end

    it { expect(response.status).to eq(204) }
    it { expect(Recipe.find_by(id: recipe_id)).to be_nil }
  end
end
