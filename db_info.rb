# frozen_string_literal: true

class DbInfo
  def self.connect_string
    {
      host: ENV["MEMOAPP_DBSERVER"],
      dbname: ENV["MEMOAPP_DB"],
      user: ENV["MEMOAPP_USER"],
      password: ENV["MEMOAPP_PASS"]
    }
  end
end
