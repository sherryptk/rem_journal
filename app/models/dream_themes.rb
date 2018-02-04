class DreamThemes < ActiveRecord::Base
  belongs_to :dream
  belongs_to :theme
end
