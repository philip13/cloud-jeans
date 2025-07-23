class N8nChatHistory < ApplicationRecord

  def self.list_numbers
    self.select(:session_id).distinct.map {|n| n.session_id }
  end
end
