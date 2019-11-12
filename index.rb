require 'eth'
require 'dotenv/load'

include Eth::Utils

def encode_params ticket
    result = bin_to_hex zpad_int(ticket[:plan], 1)
    result += bin_to_hex zpad_int(ticket[:price])
    result += bin_to_hex zpad_int(ticket[:ticketExpiration])
    result += remove_hex_prefix ticket[:contractAddress]
    return result
end

ticket = {
    plan: 1,
    price: 12000000000000000000,
    ticketExpiration: 1573533439,
    contractAddress: '0x0f5Ea0A652E851678Ebf77B69484bFcD31F9459B'
}

key = Eth::Key.new priv: ENV['PRIVATE_KEY']
params = encode_params ticket
puts "params: #{params}"
bin = keccak256(hex_to_bin params )
hex = bin_to_prefixed_hex bin
puts "hash: #{hex}"
puts "signature: 0x#{key.personal_sign(hex)}"
