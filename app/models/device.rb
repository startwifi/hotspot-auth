class Device < ActiveRecord::Base
  belongs_to :company
  belongs_to :user, touch: true
end
