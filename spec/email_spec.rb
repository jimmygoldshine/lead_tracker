require 'rails_helper'

describe Email do

  let(:email) {described_class.new}

  describe 'get' do

    it 'should output a hash' do
      expect(email.get("",5)).to be_instance_of Hash
    end

    it 'should output 5 results' do
      expect(email.get("",5).length).to be 5
    end

  end
end
