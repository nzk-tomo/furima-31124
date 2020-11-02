class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :password,           format: { with: /\A[a-z0-9]+\z/i }

  validates :nickname,           presence: true
  validates :first_name,         presence: true, format: { with: /\A[ぁ-んァ-ン一-龥]+\z/ }
  validates :last_name,          presence: true, format: { with: /\A[ぁ-んァ-ン一-龥]+\z/ }
  validates :first_name_kana,    presence: true, format: { with: /\A[ァ-ンー－]+\z/ }
  validates :last_name_kana,     presence: true, format: { with: /\A[ァ-ンー－]+\z/ }
  validates :birth,              presence: true
end
