from datastructures.hash_map import HashMap
from datastructures.linked_list import LinkedList
from datastructures.array import Array
from projects.lyricscompresser.fileutils import FileUtils
from projects.lyricscompresser.compresser import Compressor

class Program:
    def __init__(self):
        self._compressor = Compressor(FileUtils)

    def run(self):
        print("Make a selection:")
        selection = input("1. compress file into memory \n2. show word line positions \n3. decompress to output file\n4. exit: \n")
        running = True
        while running:
            match selection:
                case "1":
                    filename = input("Enter filename: ")
                    self._compressor.compress("./projects/lyricscompresser/" + filename)
                case "2":
                    self._compressor.debug_map()
                case "3":
                    filename = input("Enter filename: ")
                    self._compressor.decompress("./projects/lyricscompresser/" + filename)
                case "4":
                    running = False
                case _:
                    print("Invalid selection")
            if selection in ["1", "2", "3"]:
                running_question = input("Continue running program? (y/n): ").lower()
            while running_question != "y" and running_question != "n":
                print("Invalid selection")
                running_question = input("Continue running program? (y/n): ").lower()
            if running_question == "n":
                running = False
            if running:
                print("Make a selection:")
                selection = input("1. compress file into memory \n2. show word line positions \n3. decompress to output file\n4. exit: \n")
        
        print("Goodbye!")

def main():
    print("Lyrics Compressor")
    Program().run()

if __name__ == '__main__':
    main()