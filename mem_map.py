import os

class VariableEnumerator():
    def __init__(self):
        self.counter = 0x10;

    def enumerate_variables_in_file(self, file_name):
        variables = []
        with open(file_name, 'r+') as s:
            while True:
                line = s.readline()
                if line.startswith('.define'):
                    _, name, addr = line.split()
                    adjusted_line = line.replace(addr, self.__hex_counter_in6502format())
                    s.seek(-len(line), 1)
                    s.write(adjusted_line)
                    variables.append((self.__hex_counter(), name))

                    self.counter += 1
                elif not line:
                    break

        return variables

    def __hex_counter(self):
        return hex(self.counter).split('x')[1]

    def __hex_counter_in6502format(self):
        return '${}'.format(self.__hex_counter().zfill(2))

def enumerate_all_variables(dir):
    enumerator = VariableEnumerator()
    variables = []

    for root, dirs, files in os.walk(dir, topdown=False):
       for file in files:
           if file.endswith(".asm"):
               variables += enumerator.enumerate_variables_in_file(os.path.join(root, file))

    return variables





def save_to_map_file(file_name, variables):
    cntr = 0
    with open(file_name, 'w') as d:
        for v in variables:
            d.write('{} {}\n'.format(v[0], v[1]))
            cntr += 1

        while cntr < 24:
            d.write('| |\n')
            cntr += 1


if __name__ == '__main__':
    num_to_display = 24
    variables = enumerate_all_variables('.')
    save_to_map_file('nesdemia.mem.txt', variables[-num_to_display:])
