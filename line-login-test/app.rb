require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?

require './models'

enable :sessions

helpers do
    def current_user
        if session[:user_type] == 'parent'
            Parent.find_by(line_id: session[:parent])
        elsif session[:user_type] == 'teacher'
            Teacher.find_by(line_id: session[:teacher])
        else
            nil
        end
    end
end

get '/add_student' do
    erb :parent_add_student
end

post '/add_student' do
  # 新しい Student レコードを作成
  student = Student.create(
    name: params[:name],
    grade_id: params[:grade_id],
    school: params[:school],
    parent_id: current_user.line_id
  )

  redirect "/#{current_user.line_id}/settings"
end

get '/:id/settings' do
    @students = Student.where(parent_id: current_user.line_id)
    erb :parent_settings
end

get '/' do
    erb :index
end

get '/teacher/:id' do
    session[:teacher] = params[:id]
    erb :teacher_page
end

post '/parent' do
    name = params[:name]
    img_url = params[:img_url]
    line_id = params[:line_id]
    
    parent = Parent.create(
        name: name,
        img_url: img_url,
        line_id: line_id
    )
    
   session[:user_type] = 'parent' 
    { parent_id: line_id }.to_json
end

post '/teacher' do
    name = params[:name]
    img_url = params[:img_url]
    line_id = params[:line_id]
    
    teacher = Teacher.create(
        name: name,
        img_url: img_url,
        line_id: line_id
    )
    
    session[:user_type] = 'teacher'
    { teacher_id: line_id }.to_json
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