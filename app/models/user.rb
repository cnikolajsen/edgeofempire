class User < ActiveRecord::Base
  include FriendlyId
  friendly_id :email, :use => :slugged

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :characters, :dependent => :destroy
  has_many :campaigns

  # new columns need to be added here to be writable through mass assignment
  #attr_accessible :username, :email, :password, :password_confirmation,
  #                :first_name, :last_name,
  #                :city, :state, :postal_code, :country_id,
  #                :phone, :mobile, :fax, :email, :website, :tax_number,
  #                :enabled, :notes

  #attr_accessor :password
  #before_save :prepare_password

  #validates_presence_of :username
  #validates_uniqueness_of :username, :email, :allow_blank => true
  #validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  #validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  #validates_presence_of :password, :on => :create
  #validates_confirmation_of :password
  #validates_length_of :password, :minimum => 4, :allow_blank => true

  #def display_name
  #  if organization.length > 0
  #    organization + ' (' + full_name + ')'
  #  else
  #    full_name
  #  end
  #end
  #
  #def full_name
  #  [first_name, last_name].join(' ')
  #end
  #
  #def full_name=(name)
  #  split = name.split(' ', 2)
  #  self.first_name = split.first
  #  self.last_name = split.last
  #end
  #
  #def last_order_at
  #  # TODO: Return the time for the latest order for this user
  #  Time.local(2011, 5, 19, 20, 5, 47)
  #end
  #
  ## login can be either username or email address
  #def self.authenticate(login, pass)
  #  user = find_by_username(login) || find_by_email(login)
  #  return user if user && user.matching_password?(pass)
  #end
  #
  #def matching_password?(pass)
  #  self.password_hash == encrypt_password(pass)
  #end
  #
  #private
  #
  #def prepare_password
  #  unless password.blank?
  #    self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
  #    self.password_hash = encrypt_password(password)
  #  end
  #end
  #
  #def encrypt_password(pass)
  #  Digest::SHA1.hexdigest([pass, password_salt].join)
  #end
end
