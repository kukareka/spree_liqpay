def encode_json data
  Base64.strict_encode64 JSON.generate data
end

def decode_json
  JSON.parse Base64.strict_decode64 data
end