require 'mandrill'
class Notifications

  def self.send
    daily_messages = {}
    weekly_messages = {}

    User.wanting_daily_emails.each do |user|
      message = html_message user, 'daily'
      daily_messages[user.email] = message unless message.blank?
    end

    if Date.today.friday?
      User.wanting_weekly_emails.each do |user|
        message = html_message user, 'weekly'
        weekly_messages[user.email] = message unless message.blank?
      end
    end

    bulk_send daily_messages, 'daily' unless daily_messages.empty?
    bulk_send weekly_messages, 'weekly' unless weekly_messages.empty?
  end

  private

  def self.html_message(user, type)
    html = ""
    if type == 'weekly'
      start_date = (Date.today - 7.days).strftime('%Y-%m-%d')
    else
      start_date = nil
    end
    end_date = Date.today.prev_day.strftime('%Y-%m-%d')
    user.repos.each do |repo|
      commits = user.repo_daily_commits(repo.name, start_date, end_date)
      html += "<p><b>Changes for #{repo.name}:</b><br>" if commits.any?
      commits.each do |commit|
        info = commit[:commit]
        html += "<br>#{info[:author][:date]}<br>" +
            "Message: <a href='#{commit[:html_url]}'>#{info[:message]}</a><br>" +
            "Developer: #{info[:committer][:name]} <a href='mailto:#{info[:committer][:email]}'>" +
            "#{info[:committer][:email]}</a><br>"
      end
      html += "</p>" if commits.any?
    end
    html
  end

  def self.bulk_send(messages, type)
    mandrill = Mandrill::API.new ENV['MANDRILL_APIKEY']
    message = {}
    if type == 'weekly'
      message["subject"] = "Github Commits #{(Date.today - 7.days).strftime('%Y-%m-%d')}" +
       " to #{Date.today.prev_day.strftime('%Y-%m-%d')}"
    else
      message["subject"] = "Github Commits On #{Date.today.prev_day.strftime('%Y-%m-%d')}"
    end
    message["html"] = "*|custom|*"
    message["to"] = messages.map {|k,v| {email: k }}
    message["from_email"] = "hadiyah@playpenlabs.com"
    message["merge_vars"] = messages.map {|k,v| {rcpt: k, vars: [{name: "custom", content: v}]}}

    mandrill.messages.send message, true
  end
end
