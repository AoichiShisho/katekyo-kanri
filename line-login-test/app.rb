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

get '/:id/add_student' do
    session[:parent] = params[:id]
    erb :parent_add_student
end

get '/join_schedule/:id' do
    schedule_id = params[:id]
    user = current_user

    if user && user.is_a?(Teacher)  # ログインユーザーが教師の場合
        schedule = Schedule.find_by(id: schedule_id)
        if schedule && schedule.teacher_id.nil?
            # スケジュールのteacher_idをログインユーザーのIDに更新
            schedule.update(teacher_id: user.id)
        end
    end

    # /teacher/:id/schedule にリダイレクト
    redirect "/teacher/#{user.line_id}/schedule/request"
end

post '/:id/add_schedule' do
    session[:parent] = params[:id]
    student_id = params[:student_id]
    student = Student.find_by(id: student_id)
    
    schedule = Schedule.create(
        student_name: student.name,
        date: params[:date],
        start_time: params[:start_time],
        end_time: params[:end_time],
        parent_id: :id
    )
  
  redirect "/:id/schedule"
end

get '/teacher/:id/schedule/request' do
    session[:parent] = params[:id]
    erb :teacher_schedule_request
end

get '/:id/schedule/create' do
    session[:parent] = params[:id]
    @students = Student.where(parent_id: :id)
    erb :parent_create_schedule
end

post '/:id/add_student' do
  session[:parent] = params[:id]
  # 新しい Student レコードを作成
  student = Student.create(
    name: params[:name],
    grade_id: params[:grade_id],
    school: params[:school],
    parent_id: :id
  )

  redirect "/:id/settings"
end

post '/edit_student' do
  student_id = params[:student_id]
  name = params[:name]
  grade_id = params[:grade_id]
  school = params[:school]

  # student_id を使用して該当のお子さんを取得
  student = Student.find_by(id: student_id)

  # お子さんの情報を更新
  student.update(
    name: name,
    grade_id: grade_id,
    school: school
  )

  redirect "/#{current_user.line_id}/settings"
end

get '/edit_student/:id' do
    student_id = params[:id]
    @student = Student.find_by(id: student_id)
    erb :parent_edit_student
end

get '/:id/settings' do
    session[:parent] = params[:id]
    @students = Student.where(parent_id: :id)
    erb :parent_settings
end

get '/teacher/:id/schedule' do
    session[:parent] = params[:id]
    
    erb :teacher_schedule
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
    session[:parent] = params[:id]
    @schedules = Schedule.where(parent_id: :id)
    erb :parent_schedule
end

get '/:id/schedule/request' do
    @students = Student.where(parent_id: current_user.line_id)
    erb :parent_schedule_request
end

get '/:id/schedule/confirm' do
    erb :parent_schedule_confirm
end

get '/:id/transfer' do
    erb :parent_transfer
end