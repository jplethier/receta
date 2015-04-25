require 'spec_helper'

describe Recipe do
  let(:recipe) { FactoryGirl.build :recipe }

  subject { recipe }

  its(:valid?) { should be true }

  describe 'validations' do
    it 'requires a name' do
      expect { recipe.name = nil }.to change{ recipe.valid? }.from(true).to(false)
    end
  end
end
