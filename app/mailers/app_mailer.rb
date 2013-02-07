class AppMailer < ActionMailer::Base
  default from: "from@example.com"
  
	#Title:			competition_invitation
	#Description:	Invite a user to a competition
	#Params:		emails - Comma delimited list of email addresses
	#				competition - Competition to invite to
	def competition_invitation(emails, competition)
		return if (emails.nil? || emails.strip.length==0)
		creator = User.find_by_id(competition.creator_id)
		@competition = competition
		@invitor_name = (creator.firstname.strip.capitalize+' '+creator.lastname.strip.capitalize).strip
		@invitation_url = SITE_URL+'invitations/'+competition.id.to_s+'/'+competition.invitation_code
		mail(:to => emails, :subject => "Invitation for competition.")
	end
	
	#Title:			send_tip_default_email
	#Description:	Notifies a user that a default tip was used. Also checks if the default tip invalidates a future tip.
	#Params:		tip - CompetitionTip object containing default rider.
	def send_tip_default_email(tip)
		result = Result.where({:season_stage_id=>tip.stage_id, :rider_id=>tip.rider_id}).first
		
		@competition = Competition.find_by_id(tip.competition_id)
		@stage = Stage.find_by_id(tip.stage_id)
		@selected_rider = Rider.find_by_id(tip.rider_id)
		@disqualification_status = Result.rider_status_to_str(result.rider_status)
		@default_rider = Rider.find_by_id(tip.default_rider_id)
		
		#Find stage that has used the default rider
		invalid_tip = CompetitionTip.where({:competition_participant_id=>tip.competition_participant_id, :rider_id=>@default_rider.id, :status=>STATUS[:ACTIVE]}).first
		@invalid_stage = Stage.find_by_id(invalid_tip.stage_id) if (!invalid_tip.nil?)
		
		user = User.find_by_id(tip.competition_participant_id)
		mail(:to=>user.email, :subject=>'Competition tip defaulted.')
	end
end
