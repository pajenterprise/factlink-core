class ActivityMailer < ActionMailer::Base
  include Resque::Mailer

  helper :activity_mailer, :fact

  layout "email_notification"

  def new_activity(user_id, activity_id)
    @user = UserNotification.users_receiving('mailed_notifications')
                            .find(user_id)
    @activity = Activity[activity_id]

    blacklisted_activities = ['invites']

    return if blacklisted_activities.include? @activity.action
    return unless @activity.still_valid?
    return unless @user

    mail to: @user.email,
         subject: get_mail_subject_for_activity(@activity),
         from: from
  end

  private

  def from
    if ['development', 'testserver', 'staging'].include? Rails.env
      "\"Factlink #{Rails.env}\" <support@factlink.com>"
    else
      "\"Factlink\" <support@factlink.com>"
    end
  end

  def get_mail_subject_for_activity activity
    user = activity.user.user

    case activity.action
    when 'added_supporting_evidence', 'added_weakening_evidence', 'created_comment', 'created_sub_comment'
      factlink = activity.object.data.displaystring.truncate(50)
      "Discussion on #{factlink}"
    when 'created_conversation'
      "#{user} has sent you a message"
    when 'replied_message'
      "#{user} has replied to a message"
    when 'followed_user'
      "#{user} is now following you on Factlink"
    else
      'New notification!'
    end
  end
end
