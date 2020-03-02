# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require_relative "memo"

# メモの一覧を表示
get "/" do
  @memo_list = Memo.memo_list
  erb :list
end

# メモの新規作成画面を表示
get "/new" do
  erb :new
end

# メモを新規作成
post "/new" do
  Memo.create_memo params[:content]
  redirect "/"
end

# メモの編集画面を表示
get "/*/edit" do |id|
  @memo = Memo.read_memo(id)
  erb :edit
end

# メモの詳細を表示
get "/*" do |id|
  @memo = Memo.read_memo(id)
  erb :detail
end

# メモの内容を変更
put "/*" do |id|
  Memo.edit_memo(id, params[:content])
  redirect "/" + id
end

# メモを削除
delete "/*" do |id|
  Memo.delete_memo(id)
  redirect "/"
end
