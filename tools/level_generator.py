from enum import Enum
from math import ceil, floor

NO_LEVELS = 32


class WinCondition(Enum):
    POINTS = 0
    KILL_VIRUS = 1
    KILL_SUPER_VIRUS = 2
    USE_POWER_UP = 3
    SURVIVE = 4


class Level:
    def __init__(self, level_no: int, win_condition: WinCondition, win_threshold: int, no_viruses: int,
                 no_super_viruses: int, power_up_chance: int, attack_chance: int, max_allowed_time: int):

        if level_no not in range(1, NO_LEVELS + 1):
            raise AttributeError('level_no not in range 1..32')
        self.level_no = level_no

        if type(win_condition) != WinCondition:
            raise AttributeError('win_condition should be enum WinCondition')
        self.win_condition = win_condition

        if win_threshold not in range(1, 256):
            raise AttributeError('win_threshold not in range 1..255')
        self.win_threshold = win_threshold

        if no_viruses not in range(12):
            raise AttributeError('no_viruses not in range 0..11')
        self.no_viruses = no_viruses

        if no_super_viruses > no_viruses:
            raise AttributeError('no_smart_viruses should not be greater than no_viruses')
        if no_super_viruses not in range(12):
            raise AttributeError('no_smart_viruses not in range 0..11')
        self.no_smart_viruses = no_super_viruses

        if power_up_chance not in range(8):
            raise AttributeError('power_up_chance not in range 1..7')
        self.power_up_chance = power_up_chance

        if attack_chance not in range(8):
            raise AttributeError('attack_chance not in range 1..7')
        self.attack_chance = attack_chance

        if max_allowed_time not in range(10, 256):
            raise AttributeError('max_allowed_time not in range 10..255')
        self.max_allowed_time = max_allowed_time

    @classmethod
    def to_cc65_hex(cls, num):
        if issubclass(type(num), Enum):
            num = num.value

        return "$" + hex(num).split('x')[-1].zfill(2)

    def __repr__(self):
        return '.byte ' + self.to_cc65_hex(self.level_no) + ', ' + self.to_cc65_hex(
            self.win_condition) + ', ' + self.to_cc65_hex(self.win_threshold) + ', ' + self.to_cc65_hex(
            self.win_threshold // 10) + ', ' + self.to_cc65_hex(self.win_threshold % 10) + ', ' + self.to_cc65_hex(
            self.no_viruses) + ', ' + self.to_cc65_hex(self.no_smart_viruses) + ', ' + self.to_cc65_hex(
            self.power_up_chance) + ', ' + self.to_cc65_hex(self.attack_chance) + ', ' + self.to_cc65_hex(
            self.max_allowed_time) + ', ' + self.to_cc65_hex(self.max_allowed_time // 10) + ', ' + self.to_cc65_hex(
            self.max_allowed_time % 10) + ' ; level ' + str(self.level_no)


TUTORIAL_LEVELS = {
    1: Level(level_no=1, win_condition=WinCondition.POINTS, win_threshold=5, no_viruses=1, no_super_viruses=1,
             power_up_chance=1, attack_chance=1, max_allowed_time=60)
}


def new_level():
    for level_no in range(1, 33):
        if level_no in TUTORIAL_LEVELS:
            yield TUTORIAL_LEVELS[level_no]
        else:
            win_condition = (level_no + 1) % len(WinCondition)
            condition = WinCondition(win_condition)

            max_allowed_time = 100 - level_no * 2
            power_up_chance = 8 - ceil(level_no / 8)
            attack_chance = ceil(power_up_chance / 2.5)
            no_viruses = min(ceil(level_no * (NO_LEVELS / 11)), 11)
            no_super_viruses = no_viruses // 4

            if condition == WinCondition.POINTS:
                win_threshold = 5 + level_no // 4
            elif condition == WinCondition.USE_POWER_UP:
                win_threshold = level_no // 2
            elif condition == WinCondition.KILL_VIRUS:
                win_threshold = ceil(level_no / len(WinCondition)) * 5
            elif condition == WinCondition.KILL_SUPER_VIRUS:
                win_threshold = ceil(level_no / len(WinCondition)) * 3
            elif condition == WinCondition.USE_POWER_UP:
                win_threshold = 2 ** floor(level_no / len(WinCondition))
            elif condition == WinCondition.SURVIVE:
                win_threshold = max_allowed_time

            yield Level(level_no, condition, win_threshold, no_viruses, no_super_viruses, power_up_chance,
                        attack_chance, max_allowed_time)


if __name__ == '__main__':
    level_generator = new_level()

    with open('level.txt', 'w') as f:
        while True:
            try:
                f.write('  ')
                f.write(str(next(level_generator)))
                f.write('\n')
            except StopIteration:
                break
