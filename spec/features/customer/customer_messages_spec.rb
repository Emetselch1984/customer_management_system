require 'rails_helper'

feature '顧客の受信メッセージ画面' do
  include FeaturesSpecHelper
  let(:staff) { create(:staff) }
  let(:customer) { create(:customer) }
  let(:args) do
    {
      subject: 'これは返信です。' * 4,
      body: "これは返信です。\n" * 8
    }
  end
  let(:messages) { Message.all }

  before do
    switch_namespace(:customer)
    login_as_customer(customer)
    staff.outbound_messages.create(args)
  end

  scenario '受信メッセージ画面の表示' do
    click_link '受信メッセージ一覧'
    expect(current_path).to eq inbound_customer_messages_path
  end

end
