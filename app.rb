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

get('/operator') do
  erb(:operator)
end

get('/rider') do
  erb(:rider)
end

get('/:user/trains') do
  @user = params.fetch('user')
  @trains = Train.all()
  erb(:trains)
end

get('/:user/cities') do
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
  name = params.fetch("city_name")
  #will add cities multiple times
  # either make find city by name method, or add select form
  city = City.new({:name => name, :id => nil})
  city.save()
  time = params.fetch("time")
  @train = Train.find(params.fetch("id").to_i)
  @train.add_stop(city.id, time)
  erb(:train)
end

get('/trains/:id/edit') do
  @id = params.fetch('id').to_i
  erb(:train_edit)
end
