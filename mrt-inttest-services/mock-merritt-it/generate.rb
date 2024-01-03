# frozen_string_literal: true

require 'mustache'

node = 7777
%w[2222 3333 4444].each do |ark|
  `mkdir -p "/data/generated/ark:/1111/"`
  `cp -r /data/producer "/data/generated/ark:/1111/#{ark}|1|producer"`
  `cp -r /data/system "/data/generated/ark:/1111/#{ark}|1|system"`
  manifest = Mustache.render(File.read('/data/manifest'), { node: node, ark: "ark:/1111/#{ark}" })
  File.open("/data/generated/ark:/1111/#{ark}|manifest", 'w') do |f|
    f.write(manifest)
    f.close
  end
  `mkdir -p "/data/generated/ark:/7777/7777/1/producer"`
  `echo "hello" > "/data/generated/ark:/7777/7777/1/producer/untracked_file_with_ark"`
  `mkdir -p "/data/generated/folder"`
  `echo "hello" > "/data/generated/folder/untracked_file_without_ark"`
end
