require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require './models'

enable :sessions

helpers do
    def current_user
        Parent.find_by(line_id: session[:parent])
    end
end

get '/' do
    erb :index
end

get '/teacher/:id' do
    erb :teacher_page
end

post '/teacher/:id' do
    name = params[:name]
    img_url = params[:img_url]
    line_id = params[:line_id]
        
    parent = Parent.create(name: name, img_url: img_url, line_id: line_id)
    
    { parent_id: parent.id }.to_json
end

get '/:id' do
    session[:parent] = params[:id]
    erb :parent_page
end

get '/:id/schedule' do
    erb :parent_schedule
end

get '/:id/schedule/request' do
    erb :parent_schedule_request
end

get '/:id/schedule/confirm' do
    erb :parent_schedule_confirm
end

get '/:id/transfer' do
    erb :parent_transfer
end

get '/:id/settings' do
    erb :parent_settings
end