require 'mustache'

node = 7777
for ark in ['2222', '3333', '4444'] do
  %x[ mkdir -p "/data/generated/ark:/1111/" ]
  %x[ cp -r /data/producer "/data/generated/ark:/1111/#{ark}|1|producer" ]
  %x[ cp -r /data/system "/data/generated/ark:/1111/#{ark}|1|system" ]
  manifest = Mustache.render(File.open("/data/manifest").read, {'node': node, 'ark': "ark:/1111/#{ark}"})
  File.open("/data/generated/ark:/1111/#{ark}|manifest", 'w') do |f| 
    f.write(manifest) 
    f.close
  end
  %x[ mkdir -p "/data/generated/ark:/7777/7777/1/producer" ]
  %x[ echo "hello" > "/data/generated/ark:/7777/7777/1/producer/untracked_file_with_ark" ]
  %x[ mkdir -p "/data/generated/folder" ]
  %x[ echo "hello" > "/data/generated/folder/untracked_file_without_ark" ]

end