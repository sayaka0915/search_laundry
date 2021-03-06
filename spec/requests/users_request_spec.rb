require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:another_user) { FactoryBot.create(:user) }

  describe 'show' do
    context '認可されているユーザーの場合' do
      it '正常にレスポンスを返すこと' do
        sign_in user
        get user_path(user)
        expect(response).to be_successful
        expect(response).to have_http_status '200'
      end
    end

    context '認可されていないユーザーの場合' do
      it 'トップページにリダイレクトすること' do
        sign_in user
        get user_path(another_user)
        expect(response).to redirect_to root_path
      end

      it '302レスポンスを返すこと' do
        sign_in user
        get user_path(another_user)
        expect(response).to have_http_status '302'
      end
    end
  end
end
