class Issue
  include Mongoid::Document
  include Mongoid::Timestamps

  field :number
  field :title
  field :description
end
