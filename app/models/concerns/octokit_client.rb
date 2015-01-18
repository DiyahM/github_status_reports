module OctokitClient
  extend ActiveSupport::Concern

  included do
    private

    def github
      @github ||= Octokit::Client.new access_token: access_token
    end
  end
end
