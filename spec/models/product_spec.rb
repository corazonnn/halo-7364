require 'rails_helper'
RSpec.describe Product, type: :model do
  describe 'user,productを予め用意しておく！！' do
    let(:user) { FactoryBot.build(:user) }
    let(:product) { FactoryBot.build(:product) }
    
    it "factory_bot(product)しっかり動いてる？" do
      expect(product).to be_valid
    end
    
    it "title,language,detail,periodがあれば有効" do
      expect(product).to be_valid
    end
    it "productがuserと紐づいていないと無効(外部キーがないとダメ)" do
      product = FactoryBot.build(:product, user: nil)
      product.valid?
      expect(product.errors[:user]).to include("must exist")
    end
    it "titleがないと無効" do
      product = FactoryBot.build(:product, title: nil)
      product.valid?
      expect(product.errors[:title]).to include("can't be blank")
    end
    
    it "languageがないと無効" do
      product = FactoryBot.build(:product, language: nil)
      product.valid?
      expect(product.errors[:language]).to include("can't be blank")
    end
    
    it "detailがないと無効" do
      product = FactoryBot.build(:product, detail: nil)
      product.valid?
      expect(product.errors[:detail]).to include("can't be blank")
    end
    
    it "periodがないと無効" do
      product = FactoryBot.build(:product, period: nil)
      product.valid?
      expect(product.errors[:period]).to include("can't be blank")
    end
  end  
end
