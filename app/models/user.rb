#encoding: UTF-8”
class User < ActiveRecord::Base
  after_create  :assign_default_photo ,:create_profile 
  after_commit :assign_default_role
  validates :username, presence: true
  validates :username, uniqueness: true, if: -> { self.username.present? }
  validate :username_without_
  validate :fbaccount_without_
  validates_format_of :email,:with => Devise.email_regexp
  rolify

    
  #after_create :create_child
  def email_required?
  false
  end

 def email_changed?
  false
 end


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :playerprofile 
  has_one :gameholder
  attr_accessible :id, :username, :email, :fbaccount, :password, :password_confirmation, :remember_me,:playerphoto ,:playerprofile_attributes
  attr_accessible :role_ids
  accepts_nested_attributes_for :playerprofile   
  mount_uploader :playerphoto, PlayerPhotoUploader 
def assign_default_role
    self.add_role(:member) if self.roles.blank?
end
def create_profile
  self.build_playerprofile if !self.playerprofile
end  
def assign_default_photo
    if !self.playerphoto
    file_path="#{Rails.root}/public/LTTF_logo.png"  
    self.playerphoto = File.open(file_path)
    self.save
  end
end

 private
    def username_without_
     
       errors.add(:username, "姓名不得含有\"_\"字元請重新輸入，請用\"-\"字元取代\"_\"字元 ") unless read_attribute(:username).to_s.exclude? "_"  
      
    end
    def fbaccount_without_
     
       errors.add(:fbaccount, "FB帳號請勿輸入email!") unless read_attribute(:fbaccount).to_s.exclude? "@"  
      
    end
end
