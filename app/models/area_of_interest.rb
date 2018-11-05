class AreaOfInterest < ApplicationRecord
  self.table_name = :areas_of_interest

  def to_a
    [x, y, width, height, rotation]
  end
end
