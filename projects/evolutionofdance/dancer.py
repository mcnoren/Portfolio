class Dancer:

    def __init__(self, symbol):
        self._symbol = symbol
    
    def __str__(self):
        return self._symbol

    def __eq__(self, other: object) -> bool:
        return self._symbol == other._symbol
    
    def __ne__(self, other: object) -> bool:
        return not self._symbol == other._symbol
