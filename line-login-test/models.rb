ActiveRecord::Base.establish_connection

class Parent < ActiveRecord::Base
    has_many :students
    has_many :schedules
    
    def is_parent?
        return true
    end
    
    def is_teacher?
        return false
    end
    
    def role
        return "parent"
    end
end

class Teacher < ActiveRecord::Base
    has_many :schedules
    
    def is_parent?
        return false
    end
    
    def is_teacher?
        return true
    end
    
    def role
        return "teacher"
    end
end

class Student < ActiveRecord::Base
    belongs_to :parent
    belongs_to :grade
    has_many :schedules
end

class Grade < ActiveRecord::Base
    has_many :students
end

class Schedule < ActiveRecord::Base
    belongs_to :student
    belongs_to :teacher
end