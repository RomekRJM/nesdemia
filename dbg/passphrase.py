def encode(speed, luck, attack, level):
    bin_passphrase = "{}{}{}{}".format(int_to_bin(speed, 3), int_to_bin(luck, 3),
    int_to_bin(attack, 3), int_to_bin(level, 5))

    return bin_passphrase + int_to_bin(sum([speed, luck, attack, level]), 6)

def int_to_bin(value, width):
    return bin(value)[2:].zfill(width)

def decode(bin_passphrase):
  pass


print(encode(1, 7, 3, 15))
