require('capybara/rspec')
require('./app')
require "spec_helper"
Capybara.app = Sinatra::Application
set(:show_exceptions, false) 

describe('creating a train', {:type => :feature}) do
  it('processes user entry to create train') do
    visit('/trains/new')
    fill_in('name', :with => 'blue line')
    click_button('submit')
    expect(page).to have_content('Trains', 'blue line')
  end
end
