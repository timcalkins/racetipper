class CompetitionParticipant < ActiveRecord::Base
  attr_accessible :competition_id, :user_id
end
