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
  @user = params.fetch('user')
  erb(:home)
end

get('/:user/trains') do
  @user = params.fetch('user')
  @trains = Train.all()
  erb(:trains)
end

get('/trains/new') do
  erb(:train_form)
end

post('/operator/trains') do
  @user = "operator"
  line = params.fetch("line")
  new_train = Train.new({:line => line, :id => nil})
  new_train.save()
  @trains = Train.all()
  erb(:trains)
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
  @user = "operator"
  erb(:train)
end

delete('/trains/:id') do
  train = Train.find(params.fetch("id").to_i)
  train.delete()
  @user = "operator"
  @trains = Train.all()
  erb(:trains)
end

post('/trains/:id') do
  city = City.find(params.fetch("city_id").to_i)
  time = params.fetch("time")
  @train = Train.find(params.fetch("id").to_i)
  @train.add_stop(city.id, time)
  @user = "operator"
  erb(:train)
end

get('/trains/:id/edit') do
  @id = params.fetch('id').to_i
  @cities = City.all()
  erb(:train_edit)
end

get('/:user/cities') do
  @user = params.fetch("user")
  @cities = City.all()
  erb(:cities)
end

get('/cities/new') do
  erb(:city_form)
end

post('/operator/cities') do
  name = params.fetch("name")
  new_city = City.new({:name => name, :id => nil})
  new_city.save()
  @user = "operator"
  @cities = City.all()
  erb(:cities)
end
