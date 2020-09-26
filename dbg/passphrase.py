import itertools
import unittest

def encode(speed, luck, attack, level):
    bin_passphrase = "{}{}{}{}".format(int_to_bin(speed, 3), int_to_bin(luck, 3),
    int_to_bin(attack, 3), int_to_bin(level, 5))
    control_sum = int_to_bin(sum([speed, luck, attack, level]), 6)

    return hex(int(bin_passphrase + control_sum, 2))


def int_to_bin(value, width):
    return bin(value)[2:].zfill(width)


def decode(passphrase):
  bin_passphrase = format(int(passphrase, 16), '0>20b')
  speed = int(bin_passphrase[0:3], 2)
  luck = int(bin_passphrase[3:6], 2)
  attack = int(bin_passphrase[6:9], 2)
  level = int(bin_passphrase[9:14], 2)
  control_sum = int(bin_passphrase[14:], 2)

  if sum([speed, luck, attack, level]) != control_sum:
      raise AttributeError("Invalid passphrase")

  return (speed, luck, attack, level)


class TestGeneration(unittest.TestCase):
  def test_all_possibilities(self):
    speed = list(range(0,8))
    luck = list(range(0,8))
    attack = list(range(0,8))
    level = list(range(0,32))

    for sp, lu, at, lv in itertools.product(*[speed, luck, attack, level]):
      encoded = encode(sp, lu, at, lv)
      print("{}, speed={}, luck={}, attack={}, level={}".format(encoded[2:].upper(), sp, lu, at, lv))

      self.assertListEqual([sp, lu, at, lv], list(decode(encoded)))

  def test_decode_wrong_passphrase(self):
    self.assertRaises(AttributeError, decode, '0x1ab9c')

  def test_most_pastphrases_are_wrong(self):
    all = 2 ** 20
    wrong = 0

    for i in range(all):
      try:
        decode(hex(i))
      except AttributeError:
        wrong += 1

    self.assertTrue(float(wrong) / all > 0.75)


if __name__ == '__main__':
    unittest.main()
