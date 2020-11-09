class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :comments, dependent: :destroy
  validates :admin, inclusion: { in: [true, false] }
  validates :nickname, presence: true

  PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[\d])[a-z\d]+\z/i.freeze
  validates_format_of :password, with: PASSWORD_REGEX, on: :create, message: 'には半角英字と半角数字の両方を含めて設定してください'

  # NAME_REGEX = /\A[あ-んァ-ン一-龥]+\z/.freeze
  # NAME_KANA_REGEX = /\A[ァ-ヶー－]+\z/.freeze
  # with_options presence: true do
  #   validates :nickname
    # with_options format: { with: NAME_REGEX, message: 'には全角日本語を使用してください' } do
    #   validates :first_name
    #   validates :last_name
    # end

    # with_options format: { with: NAME_KANA_REGEX, message: 'には全角カタカナを使用してください' } do
    #   validates :first_name_kana
    #   validates :last_name_kana
    # end
  # end
  def update_with_password(params, *options)
    params.delete(:current_password)
    if params[:password].blank?
        params.delete(:password)
        params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update(params, *options)

    clean_up_passwords
    result
  end
end
