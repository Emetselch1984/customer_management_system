class Message < ApplicationRecord
  belongs_to :user
  belongs_to :staff, class_name: 'User', foreign_key: 'staff_id', optional: true
  belongs_to :root, class_name: 'Message', foreign_key: 'root_id', optional: true
  belongs_to :parent, class_name: 'Message', foreign_key: 'parent_id', optional: true
  has_many :children, class_name: 'Message', foreign_key: 'parent_id', dependent: :destroy

  before_validation do
    if parent
      self.user = parent.user
      self.root = parent.root || parent
    end
  end

  validates :subject, presence: true, length: { maximum: 80 }
  validates :body, presence: true, length: { maximum: 800 }
  scope :not_deleted, -> { where(deleted: false) }
  scope :deleted, -> { where(deleted: true) }
  scope :sorted, -> { order(created_at: :desc) }
  scope :not_discarded, -> { where(discarded: false) }
  scope :discarded, -> { where(discarded: true) }
end
