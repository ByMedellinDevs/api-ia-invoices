class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # Configure UUID as default primary key type
  self.implicit_order_column = "created_at"
end
