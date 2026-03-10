class User < ApplicationRecord
  attr_writer :login
  
  before_validation do
    self.leaf_coins ||= 0
  end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :plants
  has_many :chats
  
  def login
    @login || username || email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_hash).where(
        ["lower(username) = :value OR lower(email) = :value", { value: login.downcase }]
      ).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_hash).first
    end
  end

  validates :username, :birthdate, :leaf_coins, presence: true
  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       format: { with: /\A[a-zA-Z0-9_]+\z/, message: "ne peut contenir que des lettres, chiffres et _" },
                       length: { minimum: 3, maximum: 20 }
end
