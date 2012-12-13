class User < ActiveRecord::Base
	has_many :notifications, :dependent => :destroy
	has_many :ideas
	has_many :organization_users, :dependent => :destroy
	has_many :idea_inappropriate_reports
  accepts_nested_attributes_for :organization_users

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,:registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
		:role, :provider, :uid, :nickname, :avatar, :organization_users_attributes, :wants_notifications
	attr_accessor :is_create

  validates :email, :nickname, :presence => true
	before_save :check_for_role

  def self.no_admins
    where("role != ?", ROLES[:admin])
  end

  # use role inheritence 
  # - a role with a larger number can do everything that smaller numbers can do
#  ROLES = %w[author organization_admin admin]
  ROLES = {:user => 0, :org_admin => 50, :admin => 99}
  def role?(base_role)
    if base_role && ROLES[base_role]
      return ROLES[base_role] <= ROLES[rol]
    end
    return false
  end

	# if no role is supplied, default to the basic user role
	def check_for_role
		self.role = User::ROLES[:user] if self.role.nil? || self.role.empty?
	end

	def is_following_idea?(idea_id)
		if idea_id
			x = Notification.where(:user_id => self.id,
														:notification_type => Notification::TYPES[:follow_idea],
														:identifier => idea_id)
			if x && !x.empty?
				return true
			end
		end
	end

	##############################
	## omniauth methods
	##############################
	# get user credentials from omniauth
	def self.from_omniauth(auth)
		x = where(auth.slice(:provider, :uid)).first
		if x.nil?
			x = User.create(:provider => auth.provider, :uid => auth.uid,
											:email => auth.info.email,
											:nickname => auth.info.nickname, :avatar => auth.info.image)
		end
		return x
	end

	# if login fails with omniauth, sessions values are populated with
	# any data that is returned from omniauth
	# this helps load them into the new user registration url
	def self.new_with_session(params, session)
		if session["devise.user_attributes"]
			new(session["devise.user_attributes"], :without_protection => true) do |user|
				user.attributes = params
				user.valid?
			end
		else
			super
		end
	end

	# if user logged in with omniauth, password is not required
	def password_required?
		super && provider.blank?
	end
end
