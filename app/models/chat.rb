class Chat < ApplicationRecord
  belongs_to :plant
  belongs_to :user
end
