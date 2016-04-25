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
   	
   # 	if self.user_type == CLIENT
   #   MAX_TIME.minutes
   #  end  
   # end	
end
