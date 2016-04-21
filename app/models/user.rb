class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable
  validates :name, length: { maximum: 30 }, presence: true
  has_surveys
   belongs_to :role

   # def timeout_in
   #   2.minutes 
   # end
   # def timeout_in
   # 	binding.pry
   # 	1.minute
   # end	
end
