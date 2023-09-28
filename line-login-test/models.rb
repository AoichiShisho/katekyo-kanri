ActiveRecord::Base.establish_connection

class Parent < ActiveRecord::Base
    has_many :student
end

class Teacher < ActiveRecord::Base
    has_many :schedule
end

class Student < ActiveRecord::Base
    belongs_to :parent
    has_one :grade
    has_many :schedule
end

class Grade < ActiveRecord::Base
    has_many :student
end

class Schedule < ActiveRecord::Base
    has_one :student
end