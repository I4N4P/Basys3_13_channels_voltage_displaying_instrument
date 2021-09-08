mydic = {
    "a" : "61",
    "b" : "62",
    "B" : "42",
    "c" : "63",
    "d" : "64",
    "D" : "44",
    "e" : "65",
    "f" : "66",
    "g" : "67",
    "h" : "68",
    "H" : "48",
    "i" : "69",
    "j" : "6a",
    "k" : "6b",
    "l" : "6c",
    "m" : "6d",
    "n" : "6e",
    "o" : "6f",
    "p" : "70",
    "q" : "71",
    "r" : "72",
    "s" : "73",
    "S" : "53",
    "t" : "74",
    "u" : "75",
    "v" : "76",
    "w" : "77",
    "x" : "78",
    "y" : "79",
    "z" : "7a",

    " " : "20",
    "," : "2c",
    "." : "2e"

}

adr = 0

def adr_calc(adr):

    
    adr_str = str(hex(adr))[2:]
    if(len(adr_str)<2):
        adr_str = "0" + adr_str
    return adr_str
    

def hex_calc(char):
    global mydic
    return mydic[char]

mystring = "By Dawid Scechura Damian Herdus" #input string to generate code
mytab = mystring.split(sep=' ')
mynewstr = ""
for w in mytab:
    n = 16 - len(w)
    mynewstr = mynewstr + w + " "*n

mystring = mynewstr

for char in mystring:
    print("8'h{}: char_code = 7'h{}; //{}".format(adr_calc(adr),hex_calc(char),char))
    adr = adr + 1
while(hex(adr) != hex(256)):
    char = ' '
    print("8'h{}: char_code = 7'h{}; //{}".format(adr_calc(adr),hex_calc(char),char))
    adr = adr + 1
