class User < ActiveRecord::Base
  include FriendlyId
  friendly_id :email, :use => :slugged

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :characters, :dependent => :destroy
  has_many :campaigns

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(name:auth.extra.raw_info.name,
                            provider:auth.provider,
                            uid:auth.uid,
                            email:auth.info.email,
                            password:Devise.friendly_token[0,20]
                          )
      end

    end
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
    if user
      return user
    else
      registered_user = User.where(:email => access_token.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create(name: data["name"],
          provider:access_token.provider,
          email: data["email"],
          uid: access_token.uid ,
          password: Devise.friendly_token[0,20]
        )
      end
    end
  end

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
