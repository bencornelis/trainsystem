require('sinatra')
require('sinatra/reloader')
require('./lib/city')
require('./lib/train')
also_reload('lib/**/*.rb')
require('pg')

DB = PG.connect({:dbname => "train_system"})

get('/') do
  erb(:index)
end

get('/:user') do
  @trains = Train.all()
  @cities = City.all()
  @user = params.fetch('user')
  erb(:home)
end

get('/trains/new') do
  erb(:train_form)
end

post('/trains/new') do
  line = params.fetch("line")
  new_train = Train.new({:line => line, :id => nil})
  new_train.save()
  redirect('/operator')
end

get('/:user/trains/:id') do
  @train = Train.find(params.fetch("id").to_i)
  @user = params.fetch("user")
  erb(:train)
end

patch('/trains/:id') do
  @train = Train.find(params.fetch("id").to_i)
  new_line = params.fetch("new_line")
  @train.update({:line => new_line})
  redirect('/operator')
end

delete('/trains/:id') do
  train = Train.find(params.fetch("id").to_i)
  train.delete()
  redirect('/operator')
end

post('/trains/:id') do
  city = City.find(params.fetch("city_id").to_i)
  time = params.fetch("time")
  train = Train.find(params.fetch("id").to_i)
  train.add_stop(city.id, time)
  redirect("/operator/trains/#{train.id}")
end

get('/trains/:id/edit') do
  @id = params.fetch('id').to_i
  @cities = City.all()
  erb(:train_edit)
end

get('/cities/new') do
  erb(:city_form)
end

post('/cities/new') do
  name = params.fetch("name")
  new_city = City.new({:name => name, :id => nil})
  new_city.save()
  redirect('/operator')
end

get('/:user/cities/:id') do
  @city = City.find(params.fetch("id").to_i)
  @user = params.fetch("user")
  erb(:city)
end

get('/cities/:id/edit') do
  @id = params.fetch('id').to_i
  @trains = Train.all()
  erb(:city_edit)
end

patch('/cities/:id') do
  @city = City.find(params.fetch("id").to_i)
  new_name = params.fetch("new_name")
  @city.update({:name => new_name})
  redirect('/operator')
end

delete('/cities/:id') do
  city = City.find(params.fetch("id").to_i)
  city.delete()
  redirect('/operator')
end

post('/cities/:id') do
  train = Train.find(params.fetch("train_id").to_i)
  time = params.fetch("time")
  city = City.find(params.fetch("id").to_i)
  city.add_stop(train.id, time)
  redirect("/operator/cities/#{city.id}")
end

get('/timetable/allstops!') do
  @cities = City.all
  @trains = Train.all
  erb(:timetable)
end

get('/ticket/new') do
  @cities = City.all
  erb(:ticket)
end

get('/ticket/trains') do
  @city = City.find(params.fetch("cities").to_i)
  erb(:ticket_trains)
end

get('/success/:city_id/:train_id') do
  city_id = params.fetch("city_id").to_i
  train_id = params.fetch("train_id").to_i
  @city = City.find(city_id)
  @train = Train.find(train_id)
  erb(:ticket_success)
end
