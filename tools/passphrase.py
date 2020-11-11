import itertools
import unittest


def encode(money, speed, luck, attack, level):
    money -= 1
    speed -= 1
    luck -= 1
    attack -= 1
    level -= 1

    bin_passphrase = "{}{}{}{}{}".format(int_to_bin(money, 8), int_to_bin(speed, 3), int_to_bin(luck, 3),
                                         int_to_bin(attack, 3), int_to_bin(level, 5))
    control_sum = int_to_bin(sum([money, speed, luck, attack, level]), 6)

    return hex(int(bin_passphrase + control_sum, 2))


def int_to_bin(value, width):
    return bin(value)[2:].zfill(width)[-width:]


def decode(passphrase):
    bin_passphrase = format(int(passphrase, 16), '0>28b')
    money = int(bin_passphrase[0:8], 2) + 1
    speed = int(bin_passphrase[8:11], 2) + 1
    luck = int(bin_passphrase[11:14], 2) + 1
    attack = int(bin_passphrase[14:17], 2) + 1
    level = int(bin_passphrase[17:22], 2) + 1
    control_sum = int(bin_passphrase[22:], 2)

    if int_to_bin(sum([money, speed, luck, attack, level]), 6) != int_to_bin(control_sum, 6):
        raise AttributeError("Invalid passphrase")

    return money, speed, luck, attack, level


class TestGeneration(unittest.TestCase):
    def test_all_possibilities(self):
        money = list(range(0, 256))
        speed = list(range(0, 8))
        luck = list(range(0, 8))
        attack = list(range(0, 8))
        level = list(range(0, 32))

        for mo, sp, lu, at, lv in itertools.product(*[money, speed, luck, attack, level]):
            encoded = encode(mo, sp, lu, at, lv)
            print("{}, money={}, speed={}, luck={}, attack={}, level={}".
                  format(encoded[2:].upper(), mo, sp, lu, at, lv))
            self.assertListEqual([mo, sp, lu, at, lv], list(decode(encoded)))

    def test_decode_wrong_passphrase(self):
        self.assertRaises(AttributeError, decode, '0x5a7f831')


if __name__ == '__main__':
    unittest.main()
