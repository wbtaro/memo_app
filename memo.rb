# frozen_string_literal: true

require "securerandom"
require "pg"
require_relative "db_info"

class Memo
  attr_reader :title, :id, :content
  # メモ一覧を返却
  def self.list
    memo_list = []
    conn = PG.connect DbInfo.connect_string
    conn.exec("Select * from memo") do |result|
      result.each do |row|
        memo_list << Memo.new(row["text"].split("\n")[0], row["id"], row["text"])
      end
    end
    conn.close
    memo_list
  end

  # メモの内容を読み取る
  def self.read(id)
    memo = ""
    conn = PG.connect DbInfo.connect_string
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
    conn = PG.connect DbInfo.connect_string
    conn.exec("Insert into  memo values ('#{new_memo_id}', '#{content}')")
    conn.close
  end

  # メモを編集
  def self.edit(id, content)
    conn = PG.connect DbInfo.connect_string
    conn.exec("Update memo set text='#{content}' where id = '#{id}'")
    conn.close
  end

  # メモを削除
  def self.delete(id)
    conn = PG.connect DbInfo.connect_string
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
