ActiveRecord::Base.establish_connection

class Parent < ActiveRecord::Base
    has_many :student
end

class Teacher < ActiveRecord::Base
    
end

class Student < ActiveRecord::Base
    belongs_to :parent
    has_one :grade
end

class Grade < ActiveRecord::Base
    has_many :students
end