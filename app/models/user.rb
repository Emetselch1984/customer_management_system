class User < ApplicationRecord
  authenticates_with_sorcery!
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  has_many :event, class_name: 'StaffEvent', dependent: :destroy
  has_many :addresses
  has_one :home_address, dependent: :destroy, autosave: true
  has_one :work_address, dependent: :destroy, autosave: true
  has_many :phones, dependent: :destroy
  has_many :personal_phones, -> { where(address_id: nil).order(:id) },
           class_name: 'Phone', autosave: true
  has_many :entries, dependent: :destroy
  has_many :programs, through: :entries
  # programを作成したスタッフは先にprogramsを作成しないと削除できない
  has_many :programs, foreign_key: 'registrant_id', dependent: :restrict_with_exception
  has_many :messages
  has_many :outbound_messages, class_name: 'CustomerMessage', foreign_key: 'user_id'
  has_many :inbound_messages, class_name: 'StaffMessage', foreign_key: 'user_id'
end
