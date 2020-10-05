from datetime import datetime
import itertools
import unittest


def encode(money, speed, luck, attack, level):
    bin_passphrase = "{}{}{}{}{}".format(int_to_bin(money, 8), int_to_bin(speed, 3), int_to_bin(luck, 3),
                                         int_to_bin(attack, 3), int_to_bin(level, 5))
    control_sum = int_to_bin(compute_control_sum(money, speed, luck, attack, level), 6)

    return hex(int(bin_passphrase + control_sum, 2))


def int_to_bin(value, width):
    return bin(value)[2:].zfill(width)


def compute_control_sum(money, speed, luck, attack, level):
    control_sum = sum([money, speed, luck, attack, level])
    return control_sum if control_sum <= 255 else control_sum - 256


def decode(passphrase):
    bin_passphrase = format(int(passphrase, 16), '0>28b')
    money = int(bin_passphrase[0:8], 2)
    speed = int(bin_passphrase[8:11], 2)
    luck = int(bin_passphrase[11:14], 2)
    attack = int(bin_passphrase[14:17], 2)
    level = int(bin_passphrase[17:22], 2)
    control_sum = int(bin_passphrase[22:], 2)

    if compute_control_sum(money, speed, luck, attack, level) != control_sum:
        raise AttributeError("Invalid passphrase")

    return (money, speed, luck, attack, level)


class TestGeneration(unittest.TestCase):
    def test_all_possibilities(self):
        money = list(range(0, 256))
        speed = list(range(0, 8))
        luck = list(range(0, 8))
        attack = list(range(0, 8))
        level = list(range(0, 32))

        for sp, lu, at, mo, lv in itertools.product(*[money, speed, luck, attack, level]):
            encoded = encode(mo, sp, lu, at, lv)
            # print("{}, money={}, speed={}, luck={}, attack={}, level={}".format(encoded[2:].upper(), mo, sp, lu, at, lv))

            self.assertListEqual([mo, sp, lu, at, lv], list(decode(encoded)))

    def test_decode_wrong_passphrase(self):
        self.assertRaises(AttributeError, decode, '0x1ab9c88')

    def test_most_pastphrases_are_wrong(self):
        all = 2 ** 28
        wrong = 0
        percent = 0

        for i in range(all):
            try:
                decode(hex(i))
                if i % 2684354 == 0:
                    print('{}: Checked {} percent.'.format(datetime.utc_now(), percent))
                    percent += 1
            except AttributeError:
                wrong += 1

        self.assertTrue(float(wrong) / all > 0.75)


if __name__ == '__main__':
    unittest.main()
