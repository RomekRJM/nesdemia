from enum import Enum
from math import ceil, floor, log

NO_LEVELS = 32
MAX_LEVEL_DURATION = 60
NO_POWER_UP = 255


class WinCondition(Enum):
    POINTS = 0
    KILL_VIRUS = 1
    KILL_SUPER_VIRUS = 2
    USE_POWER_UP = 3
    SURVIVE = 4


class Level:
    def __init__(self, level_no: int, win_condition: WinCondition, win_threshold: int, no_viruses: int,
                 super_virus_chance: int, power_up_chance: int, attack_chance: int, max_allowed_time: int):

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

        if super_virus_chance not in range(9):
            raise AttributeError('super_virus_chance not in range 0..8')
        self.no_smart_viruses = super_virus_chance

        allowed_power_ups = list(range(32)) + [NO_POWER_UP]

        if power_up_chance not in allowed_power_ups:
            raise AttributeError('power_up_chance not in range 0..31, NO_POWER_UP')
        self.power_up_chance = power_up_chance

        if attack_chance not in allowed_power_ups:
            raise AttributeError('attack_chance not in range 0..31, NO_POWER_UP')
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
    1: Level(level_no=1, win_condition=WinCondition.POINTS, win_threshold=5, no_viruses=1, super_virus_chance=0,
             power_up_chance=NO_POWER_UP, attack_chance=NO_POWER_UP, max_allowed_time=60),
    2: Level(level_no=2, win_condition=WinCondition.USE_POWER_UP, win_threshold=3, no_viruses=2, super_virus_chance=0,
             power_up_chance=16, attack_chance=NO_POWER_UP, max_allowed_time=40),
    3: Level(level_no=3, win_condition=WinCondition.KILL_VIRUS, win_threshold=3, no_viruses=2, super_virus_chance=0,
             power_up_chance=16, attack_chance=16, max_allowed_time=35),
    4: Level(level_no=4, win_condition=WinCondition.SURVIVE, win_threshold=15, no_viruses=5, super_virus_chance=0,
             power_up_chance=16, attack_chance=24, max_allowed_time=15),
    5: Level(level_no=5, win_condition=WinCondition.KILL_SUPER_VIRUS, win_threshold=2, no_viruses=1, super_virus_chance=8,
             power_up_chance=7, attack_chance=7, max_allowed_time=35),
}


def new_level():
    for level_no in range(1, 33):
        if level_no in TUTORIAL_LEVELS:
            yield TUTORIAL_LEVELS[level_no]
        else:
            seed = level_no - len(TUTORIAL_LEVELS)
            win_condition = (seed-1) % len(WinCondition)
            condition = WinCondition(win_condition)

            max_allowed_time = ceil(MAX_LEVEL_DURATION - 0.04 * seed * seed) // 5 * 5
            power_up_chance = 0
            attack_chance = 0
            no_viruses = max(1, ceil(3.2 * log(seed, 3)))
            super_virus_chance = max(0, floor(1.8 * log(seed, 4)) - 1)

            if condition == WinCondition.POINTS:
                win_threshold = 5 + seed // 4
            elif condition == WinCondition.USE_POWER_UP:
                win_threshold = seed // 2
            elif condition == WinCondition.KILL_VIRUS:
                win_threshold = ceil(seed / len(WinCondition)) * 5
            elif condition == WinCondition.KILL_SUPER_VIRUS:
                win_threshold = ceil(seed / len(WinCondition)) * 3
                super_virus_chance = max(1, super_virus_chance)
            elif condition == WinCondition.USE_POWER_UP:
                win_threshold = 2 ** floor(seed / len(WinCondition))
            elif condition == WinCondition.SURVIVE:
                max_allowed_time = MAX_LEVEL_DURATION - (ceil(0.75 * max_allowed_time) // 5 * 5)
                win_threshold = max_allowed_time

            yield Level(level_no, condition, win_threshold, no_viruses, super_virus_chance, power_up_chance,
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
