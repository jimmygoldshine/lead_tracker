require 'rails_helper'

feature 'emails' do

  context 'no emails pulled through' do
    scenario 'show no emails message' do
      visit '/emails'
      expect(page).to have_content 'No emails are being pulled through!'
    end
  end
end
