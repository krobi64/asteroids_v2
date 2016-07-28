namespace 'edition' do
  desc 'Send the newspaper to subscriber list'
  task :deliver_dmp => :environment do
    @edition = Edition.current
    Subscription.subscribed_users.each do |user|
      puts "USER: #{user} confirmed? #{user.confirmed?}"
      UserMailer.daily_newspaper(user, @edition).deliver if user.confirmed?
    end
  end

  desc 'Generate Draft Copy of DMP'
  task :generate_draft => :environment do
    if Edition.draft.blank?
      Edition.create_draft(Date.today)
    end
  end

  desc 'Automatically publish scheduled drafts'
  task :publish => :environment do
    Edition.where(state: 'draft').where("publish_date IS NOT NULL AND publish_date < '#{Time.zone.now}'").all.each do |edition|
      edition.publish!
    end
  end
end
