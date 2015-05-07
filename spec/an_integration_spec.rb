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

describe('changing a train line', {:type => :feature}) do
  it('processes operator entry to change a train line') do
    new_train = Train.new({:line => 'purple', :id => nil})
    new_train.save()
    visit("/operator/trains/#{new_train.id}")
    click_link("Edit")
    fill_in("new_line", :with => "orange")
    click_button("Change line")
    expect(page).to have_content("orange")
  end
end

describe('deleting a train', {:type => :feature}) do
  it('deletes a train chosen by an operator') do
    new_train = Train.new({:line => 'purple', :id => nil})
    new_train.save()
    visit("/trains/#{new_train.id}/edit")
    click_button("Delete")
    expect(page).to have_no_content("purple")
  end
end

describe('adding a stop to a train', {:type => :feature}) do
  it('processes operator entry of time and city to add a stop to a train') do
    new_train = Train.new({:line => 'purple', :id => nil})
    new_train.save()
    new_city = City.new({:name => 'Portland', :id => nil})
    new_city.save()
    visit("/trains/#{new_train.id}/edit")
    fill_in("time", :with => "01:23:45")
    check(new_city.id)
    click_button("Add stop")
    expect(page).to have_content("Portland: 01:23:45")
  end
end

describe('adding a city', {:type => :feature}) do
  it('processes operator entry to add a new city') do
    visit('/cities/new')
    fill_in('name', :with => 'Sebastopol')
    click_button('submit')
    expect(page).to have_content('Sebastopol')
  end
end

describe('changing a city name', {:type => :feature}) do
  it('processes operator entry to change a city name') do
    new_city = City.new({:name => 'Portland', :id => nil})
    new_city.save()
    visit("/operator/cities/#{new_city.id}")
    click_link("Edit")
    fill_in("new_name", :with => "pdx")
    click_button("Change name")
    expect(page).to have_content("pdx")
  end
end

describe('deleting a city', {:type => :feature}) do
  it('deletes a city chosen by an operator') do
    new_city = City.new({:name => 'purple', :id => nil})
    new_city.save()
    visit("/cities/#{new_city.id}/edit")
    click_button("Delete")
    expect(page).to have_no_content("purple")
  end
end

describe('adding a stop to a city', {:type => :feature}) do
  it('processes operator entry of time and train to add a stop to a city') do
    new_train = Train.new({:line => 'purple', :id => nil})
    new_train.save()
    new_city = City.new({:name => 'Portland', :id => nil})
    new_city.save()
    visit("/cities/#{new_city.id}/edit")
    fill_in("time", :with => "01:23:45")
    check(new_train.id)
    click_button("Add stop")
    expect(page).to have_content("purple: 01:23:45")
  end
end

describe('buying a ticket', {:type => :feature}) do
  it('allows a user to view all trains passing through a particular city and see destinations on that page') do
    new_train = Train.new({:line => 'purple', :id => nil})
    new_train.save()
    new_city = City.new({:name => 'Portland', :id => nil})
    new_city.save()
    new_city.add_stop(new_train.id, '12:20:03')
    visit('/ticket/new')
    select new_city.name, from: "cities"
    click_button('List trains')
    click_link('purple')
    expect(page).to have_content('Thanks! The next stop for purple in Portland is at 12:20:03.')
  end
end
