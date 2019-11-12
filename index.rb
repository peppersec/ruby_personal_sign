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
    price: 1200000000000000000,
    ticketExpiration: 1573540866,
    contractAddress: '0x03Ebd0748Aa4D1457cF479cce56309641e0a98F5'
}

key = Eth::Key.new priv: ENV['PRIVATE_KEY']
params = encode_params ticket
puts "params: #{params}"
msg_bin = keccak256(hex_to_bin params )
msg_hex = bin_to_prefixed_hex msg_bin

# prefix_with_msg = keccak256 prefix_message msg_bin
# puts "prefix msg #{bin_to_prefixed_hex prefix_with_msg}"
puts "hash: #{msg_hex}"
puts "signature: 0x#{key.personal_sign(msg_bin)}"
sig = key.personal_sign(msg_bin)
puts "signer: #{key.address.downcase}"

puts "recover #{public_key_to_address Eth::Key.personal_recover(msg_hex, sig)}" 