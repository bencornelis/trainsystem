require('capybara/rspec')
require('./app')
require "spec_helper"
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('creating a train', {:type => :feature}) do
  it('processes user entry to create train') do
    visit('/trains/new')
    fill_in('line', :with => 'blue line')
    click_button('submit')
    expect(page).to have_content('blue line')
  end
end

describe('changing a train name', {:type => :feature}) do
  it('processes operator entry to change a train name') do
    new_train = Train.new({:line => 'purple', :id => nil})
    new_train.save()
    visit("/operator/trains/#{new_train.id}")
    click_link("Edit")
    fill_in("new_line", :with => "orange")
    click_button("Change line")
    expect(page).to have_content("orange")
  end
end
