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

  def get_repos
    new_repos = github.repos
    new_repos.each do |r|
      self.repos.find_or_create_by(name: r['full_name'])
    end
    self.repos
  end


end

