# frozen_string_literal: true

class DbInfo
  def self.connect_string
    {
      host: "13.78.57.122",
      dbname: "postgres",
      user: ENV["MEMOAPP_USER"],
      password: ENV["MEMOAPP_PASS"]
    }
  end
end
