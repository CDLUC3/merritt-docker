require 'json'

b = false
while !b do
  obj = { foo: 'bar' }
  puts obj.to_json
  sleep 10
end