# frozen_string_literal: true

require "securerandom"
require "pg"
require "./db_info"

class Memo
  # 接続情報をハッシュに詰める
  CONNECT_STRING = {
    host: DbInfo::HOST,
    user: DbInfo::USER,
    dbname: DbInfo::DATABASE,
    password: DbInfo::PASSWORD
  }
  attr_reader :title, :id, :content

  # メモ一覧を返却
  def self.list
    memo_list = []
    conn = PG.connect CONNECT_STRING
    conn.exec("Select * from memo") do |result|
      result.each do |row|
        p row
        memo_list << Memo.new(row["text"].split("\n")[0], row["id"], row["text"])
      end
    end
    conn.close
    memo_list
  end

  # メモの内容を読み取る
  def self.read(id)
    memo = ""
    conn = PG.connect CONNECT_STRING
    conn.exec("Select * from memo where id='#{id}'") do |result|
      result.each do |row|
        memo = Memo.new(row["text"].split("\n")[0], row["id"], row["text"])
      end
    end
    conn.close
    memo
  end

  # メモを新規作成
  def self.create(content)
    conn = PG.connect CONNECT_STRING
    conn.exec("Insert into  memo values ('#{new_memo_id}', '#{content}')")
    conn.close
  end

  # メモを編集
  def self.edit(id, content)
    conn = PG.connect CONNECT_STRING
    conn.exec("Update memo set text='#{content}' where id = '#{id}'")
    conn.close
  end

  # メモを削除
  def self.delete(id)
    conn = PG.connect CONNECT_STRING
    conn.exec("Delete from memo where id = '#{id}'")
    conn.close
  end

  def initialize(title, id, content = "")
    @title = title
    @id = id
    @content = content
  end

  private
    # 新規作成するメモのIDを決定
    def self.new_memo_id
      SecureRandom.uuid
    end
end
