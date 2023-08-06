class Commit
  include Mongoid::Document
  include Mongoid::Timestamps

  field :sha
  field :author_name
  field :author_email
  field :date, type: DateTime
  field :message
  field :diff
end
