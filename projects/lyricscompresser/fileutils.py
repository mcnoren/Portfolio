class FileUtils:
    @staticmethod
    def read(filename: str) -> list[str]:
        list = []
        try:
            with open(filename, 'r') as file:
                for line in file:
                    list.append(line.strip())
        except FileNotFoundError:
            print("File not found")
        return list
    
    @staticmethod
    def write(filename: str, lines: list[str]):
        try:
            with open(filename, 'w') as file:
                for line in lines:
                    file.write(line)
        except FileNotFoundError:
            print("File not found")