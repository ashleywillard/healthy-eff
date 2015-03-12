class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name
  # attr_accessible :title, :body

  has_many :days, :dependent => :destroy
  has_many :activities, through: :days
  accepts_nested_attributes_for :days, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true

  attr_protected :is_admin


end
