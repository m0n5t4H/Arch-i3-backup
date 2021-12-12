import subprocess
import sys


# Config
TRUNCATE = True
TRUNCATE_LENGTH = 3


# TODO: Get this from polybar config
# LABEL
# %country% -> Displays the country with your connect to, can
# be truncated to TRUNCATE_LENGTH.
# %server% -> Displays the server your are connected to, if
# truncated the it only show the letters
# %city% -> Displays city
# %ip% -> Displays ip
# %uptime% -> Displays uptime, can be configure by charging TIME_LABEL
# %tech% -> Displays the technology being used
LABEL = "%server% %uptime%"

# TIME_LABEL
# %h -> hours
# %m -> minutes
# %s -> seconds
TIME_LABEL = "%h:%m"

trunc = lambda x: x[0:TRUNCATE_LENGTH]if TRUNCATE else x
def msgHandler(args):
    (message, _) = subprocess.Popen(args,stdout=subprocess.PIPE).communicate()
    return message.decode('utf-8')

def display():
    global LABEL, TIME_LABEL, TRUNCATE
    message = msgHandler(['nordvpn','status'])

    if 'Disconnected' in message or 'check your internet' in message:
        if TRUNCATE:
            print("DC")
        else:
            print("Disconnected")
    elif 'Status' in message:
        rows = list(map(lambda x: list(x.split()), message.split("\n")))


        # Got to love pattern matching
        h = 0
        m = 0
        s = 0
        for row in rows:
            match row:
                case ["Country:", country]:
                    LABEL = LABEL.replace("%country%",trunc(country))
                case ["Current", "server:", server]:
                    LABEL = LABEL.replace("%server%", server[:2].upper()) if TRUNCATE else server
                case ["City:", city]:
                    LABEL = LABEL.replace("%city%", city)
                case ["Your", "new", "IP:", ip]:
                    LABEL = LABEL.replace("%ip%",ip)
                case ["Current", "technology:", tech]:
                    LABEL = LABEL.replace("%tech%",tech)
                # The time format is a bit messy
                case ["Uptime:",seconds, _]:
                    s = seconds
                case ["Uptime:", minutes, _ , seconds, _]:
                    m = minutes
                    s = seconds
                case ["Uptime:", hours, _ , minutes, _ , seconds, _]:
                    h = hours
                    m = minutes
                    s = seconds


        TIME_LABEL = TIME_LABEL.replace("%h", format(int(h),'02d'))
        TIME_LABEL = TIME_LABEL.replace("%m", format(int(m),'02d'))
        TIME_LABEL = TIME_LABEL.replace("%s", format(int(s),'02d'))
        LABEL = LABEL.replace("%uptime%", TIME_LABEL)

        print(LABEL)
    else:
        print("Whoops!")


def click():
    # Check if connected
    message = msgHandler(['nordvpn', 'status'])
    # If disconnected
    if "Status: Disconnected" in message:
        msgHandler(['nordvpn', 'connect'])
    # If connected
    else:
        msgHandler(["nordvpn","disconnect"])



def main(argv):
    if len(argv) == 0:
        display()
    else:
        click()

if __name__ == "__main__":
    main(sys.argv[1:])
