class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validate :password_complexity

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  # attr_accessible :title, :body

  has_many :months, :dependent => :destroy
  has_many :days, through: :months

  attr_protected :admin

  def password_complexity
    if not password.match(/^(?=.*[a-z]).+$/)
      errors.add :password, "must include at least one lowercase character"
    end
    if not password.match(/^(?=.*[A-Z]).+$/)
      errors.add :password, "must include at least one uppercase character"
    end
    if not password.match(/^(?=.*\d).+$/)
      errors.add :password, "must include at least one number"
    end
    if not password.match(/^(?=.*(_|[^\w])).+$/)
      errors.add :password, "must include at least one special character"
    end
  end

end
