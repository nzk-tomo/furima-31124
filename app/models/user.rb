class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :items
  has_many :trades
  has_many :comments

  VALID_PASSWORD_REGEX = /\A[a-z0-9]+\z/i.freeze
  validates :password, format: { with: VALID_PASSWORD_REGEX }

  VALID_NAME_REGEX = /\A[ぁ-んァ-ン一-龥]+\z/.freeze
  VALID_NAME_KANA_REGEX = /\A[ァ-ヶー－]+\z/.freeze
  with_options presence: true do
    validates :nickname
    validates :first_name,      format: { with: VALID_NAME_REGEX, message:"は全角で入力願います"}
    validates :last_name,       format: { with: VALID_NAME_REGEX, message:"は全角で入力願います"}
    validates :first_name_kana, format: { with: VALID_NAME_KANA_REGEX, message:"は全角カタカナで入力願います" }
    validates :last_name_kana,  format: { with: VALID_NAME_KANA_REGEX, message:"は全角カタカナで入力願います" }
    validates :birth
  end
end
