ActiveRecord::Base.establish_connection

class Parent < ActiveRecord::Base
    has_many :student
end

class Teacher < ActiveRecord::Base
    
end

class Student < ActiveRecord::Base
    belongs_to :parent
end