from datastructures.hash_map import HashMap
from datastructures.linked_list import LinkedList
from datastructures.array import Array
from projects.lyricscompresser.fileutils import FileUtils


class Compressor:
    def __init__(self, file_utils: FileUtils):
        self._file_utils = file_utils
        self._hashmap = HashMap()
    
    def compress(self, filename: str):
        lines = self._file_utils.read(filename)
        index = 0
        for line in lines:
            words = line.split()
            words += ['\n']
            for word in words:
                if word in self._hashmap:
                    self._hashmap[word].append(index)
                else:
                    self._hashmap[word] = LinkedList()
                    self._hashmap[word].append(index)
                index += 1
    
    def debug_map(self):
        for key in self._hashmap:
            print(f"{key}: {self._hashmap[key]}")
    
    def decompress(self, filename: str):
        keys = self._hashmap.keys()
        length = 0
        for key in keys:
            for index in self._hashmap[key]:
                length += 1
        words = Array(length)
        for key in keys:
            for index in self._hashmap[key]:
                words[index] = key
        lines = []
        index = 0
        for word in words:
            if len(lines) <= index:
                lines.append('')
            if word == '\n':
                lines[index] += '\n'
                index += 1
            else:
                lines[index] += str(word) + ' '
        self._file_utils.write(filename, lines)