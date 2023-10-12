require 'bundler/setup'
require 'sinatra/base'
Bundler.require
require 'sinatra/reloader' if development?

require './models'

enable :sessions

helpers do
    def current_user
        session[:user]
    end
    
    def authenticate!
        if !current_user
            redirect "/"
        end
    end
    
    def authenticate_parent!
        if !(current_user && current_user.is_parent?)
            redirect "/"
        end
    end
    
    def authenticate_teacher!
        if !(current_user && current_user.is_teacher?)
            redirect "/"
        end
    end
end

before do
    if Sinatra::Base.environment == :development
        @liff_id = "2001000373-16QAp0gM"
    else
        @liff_id = "2001000375-J0eV1n54"
    end
    
    if Grade.all.empty?
        6.times do |i|
            Grade.create(grade_number: i + 1, label: i < 3 ? "中学#{i + 1}年生" : "高校#{i % 3 + 1}年生")
        end
    end
end

get '/' do
    @title = "ログイン"
    erb :index
end

post "/account" do
    if parent = Parent.find_by(line_id: params[:userId])
        session[:user] = parent
        content_type :json
        return current_user.to_json
    elsif teacher = Teacher.find_by(line_id: params[:userId])
        session[:user] = teacher
        content_type :json
        return current_user.to_json
    else
        session[:temp] = params
        return nil
    end
end

get "/signup" do
    @title = "新規登録"
    erb :signup
end

post "/signup" do
    if params[:user_type] == "parent"
        parent = Parent.create(
            name: session[:temp]["displayName"],
            img_url: session[:temp]["pictureUrl"],
            line_id: session[:temp]["userId"]
        )
        session[:temp] = nil
        session[:user] = parent
        redirect "/home"
    elsif params[:user_type] == "teacher"
        teacher = Teacher.create(
            name: session[:temp]["displayName"],
            img_url: session[:temp]["pictureUrl"],
            line_id: session[:temp]["userId"]
        )
        session[:temp] = nil
        session[:user] = teacher
        redirect "/home"
    else
        redirect "/"
    end
end

post "/logout" do
    session[:user] = nil
end

get "/home" do
    authenticate!
    @title = "ホーム"
    erb :home
end

get "/schedule/requests" do
    authenticate!
    if current_user.is_parent?
        @title = "スケジュール申請"
        @schedules = current_user.schedules.where(teacher_id: nil)
    elsif current_user.is_teacher?
        @title = "スケジュール承認"
        @schedules = Schedule.where(teacher_id: nil)
    end
    erb :schedule_request
end

get "/schedule/create" do
    authenticate_parent!
    @title = "日程追加"
    @students = current_user.students
    erb :create_schedule
end

post "/add_schedule" do
    authenticate_parent!
    current_user.schedules.create(**params, parent_id: current_user.id)
    redirect "/schedule/requests"
end

get "/settings" do
    authenticate!
    if current_user.is_parent?
        @title = "設定"
        @students = current_user.students
    elsif current_user.is_teacher?
        redirect "/home"
    end
    erb :settings
end

get "/add_student" do
    authenticate_parent!
    @title = "お子さんを追加"
    @grades = Grade.all
    erb :student
end

post "/add_student" do
    authenticate_parent!
    current_user.students.create(**params, grade_id: params[:grade_id].to_i)
    redirect "/settings"
end

get "/edit_student/:id" do
    authenticate_parent!
    @title = "お子さんを編集"
    @is_edit = true
    @student = current_user.students.find(params[:id])
    @grades = Grade.all
    erb :student
end

post "/edit_student/:id" do
    authenticate_parent!
    student = current_user.students.find(params[:id])
    student && student.update(**params, grade_id: params[:grade_id].to_i)
    redirect "/settings"
end

get "/approval/:id" do
    authenticate_teacher!
    schedule = Schedule.find(params[:id])
    schedule.teacher_id = current_user.id
    schedule.save
    redirect "/schedule/requests"
end

get "/schedules" do
    authenticate!
    @title = "カテキョ日程"
    if current_user.is_parent?
        @schedules = current_user.schedules.where(teacher_id: !nil)
    elsif current_user.is_teacher?
        @schedules = current_user.schedules
    end
    erb :schedules
end

post "/update_review/:id" do
    authenticate_teacher!
    schedule = Schedule.find(params[:id])
    schedule.review = params[:review]
    schedule.save
    redirect "/schedules"
end

get "/salary" do
    authenticate_teacher!
    @title = "勤怠"
    erb :salary
end

get "/error" do
    @title = "エラーが発生しました"
    erb :error
end
