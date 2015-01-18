class User < ActiveRecord::Base
  has_many :repos, -> { order 'created_at ASC' }
  accepts_nested_attributes_for :repos

  include OctokitClient

  def self.find_or_create_from_auth_hash auth_hash
    info = auth_hash['info']
    User.find_or_create_by(email: info['email']) do |user|
      user.gh_username = info['nickname']
      user.name = info['name']
      user.image = info['image']
      user.access_token = auth_hash['credentials']['token']
    end
  end

  def self.wanting_daily_emails
    User.includes(:repos).where(repos: { email_frequency: 'daily' })
  end

  def self.wanting_weekly_emails
    User.includes(:repos).where(repos: { email_frequency: 'weekly' })
  end
  

  def get_repos
    new_repos = github.repos
    github.list_organizations.each do |org|
      new_repos += github.org_repositories(org['login']) 
    end
    
    new_repos.each do |r|
      self.repos.find_or_create_by(name: r['full_name'])
    end
    self.repos
  end

  def repo_daily_commits(repo_name, start_date, end_date)
    if start_date
      return github.commits_between(repo_name, start_date, end_date)
    else
      return github.commits_on(repo_name, end_date) 
    end
  end

end

