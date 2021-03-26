#!/usr/bin/python3

import time
import re
import os
import subprocess as s


ansi_escape = re.compile(r'''
    \x1B  # ESC
    (?:   # 7-bit C1 Fe (except CSI)
        [@-Z\\-_]
    |     # or [ for CSI, followed by a control sequence
        \[
        [0-?]*  # Parameter bytes
        [ -/]*  # Intermediate bytes
        [@-~]   # Final byte
    )
''', re.VERBOSE)


class StartFailedException(Exception):
    pass


class BTExitedException(Exception):
    pass


def linetransfer(line):
    line = "".join(line)
    line = line.strip()
    line = ansi_escape.sub('', line)
    return line


def readline(stream):
    breakers = [
        ["(yes/no): ", -1],
        ["...", -1],
        ["".join([chr(i) for i in [93,27,91,48,109,35]]), -1], # ["]#",-1]
    ]
    line = []
    while True:
        c = stream.read(1)
        if c == "\n":
            if len(line):
                return linetransfer(line)
            else:
                continue
        line.append(c)
        for breaker in breakers:
            if breaker[0][breaker[1]+1] == c:
                breaker[1] += 1
                if breaker[1]+1 == len(breaker[0]):
                    return linetransfer(line)
            else:
                breaker[1] = -1


def expect(bt, patterns):
    print("Waiting for patterns: " + str(patterns))
    exprs = []
    for pattern in patterns:
        if type(pattern) is re.Pattern:
            exprs.append(pattern)
        else:
            exprs.append(re.compile(pattern))
    while True:
        if bt.poll() is not None:
            raise BTExitedException()
        line = readline(bt.stdout)
        print("Got: " + str(line))
        for i,expr in enumerate(exprs):
           if expr.match(line):
               print("It matched "+str(i))
               bt.stdin.write("\n")
               return i

def btcmd(bt, cmd):
    expect(bt, ["\[bluetooth\]#"])
    print("!"+cmd)
    bt.stdin.write(cmd+"\n")


def stop_bt(bt):
    btcmd(bt, "pairable off")
    btcmd(bt, "discoverable off")
    btcmd(bt, "agent off")
    btcmd(bt, "power off")
    expect(bt, ["Changing power off succeeded"])
    with open('/tmp/btcontrol-ready','w') as f:
        f.write('0')


def start_bt(bt):
    btcmd(bt, "power on")
    if expect(bt, ["Changing power on succeeded", "Failed to set power on.*"]) == 1:
        raise StartFailedException()

    btcmd(bt, "agent NoInputNoOutput")
    if expect(bt, ["Agent registered", "Failed to register agent.*"]) == 1:
        raise StartFailedException()

    btcmd(bt, "default-agent")
    if expect(bt, ["Default agent request successful", "Failed to request default agent.*"]) == 1:
        raise StartFailedException()

    btcmd(bt, "pairable on")
    btcmd(bt, "discoverable on")


def restart_bt(bt):
    print("!!Stopping")
    stop_bt(bt)
    print("!!Starting")
    try:
        start_bt(bt)
    except StartFailedException:
        print("ERROR: Startup failed, restart BT")
        bt.kill()
        raise BTExitedException()


def await_events(bt):
    passkey = re.compile(r"\[agent\] Confirm passkey .* \(yes/no\):")
    pairing = re.compile(r"\[agent\] Accept pairing \(yes/no\):")
    service = re.compile(r"\[agent\] Authorize service .* \(yes/no\):")
    new_device = re.compile(r"\[NEW\] Device (([0-9A-Z]{2}:){5}[0-9A-Z]{2}).*")
    #new_device = re.compile(r"\[CHG\] Device (([0-9A-Z]{2}:){5}[0-9A-Z]{2}) Connected: yes.*")
    while True:
        if bt.poll() is not None:
            print("Error: bt exited with code " + str(bt.poll()))
            raise BTExitedException()
        line = readline(bt.stdout)
        print("BT: "+str(line))
        if (new_device.fullmatch(line)):
            print("!TRUSTING")
            print("trust %s" % new_device.fullmatch(line).group(1), file=bt.stdin)
        if (passkey.fullmatch(line)):
            print("!YES")
            print("yes", file=bt.stdin)
            #s.Popen(["pactl", "set-sink-volume", "@DEFAULT_SINK@", "50%"])
            #s.Popen(["/usr/bin/play", "/usr/local/share/btcontrol/keyok1.mp3"])
        if (pairing.fullmatch(line)):
            print("!YES")
            print("yes", file=bt.stdin)
            #s.Popen(["pactl", "set-sink-volume", "@DEFAULT_SINK@", "50%"])
            #s.Popen(["/usr/bin/play", "/usr/local/share/btcontrol/keyok2.mp3"])
        if (service.fullmatch(line)):
            print("!YES")
            print("yes", file=bt.stdin)
            #s.Popen(["pactl", "set-sink-volume", "@DEFAULT_SINK@", "50%"])
            #s.Popen(["/usr/bin/play", "/usr/local/share/btcontrol/keyok3.mp3"])


def bt_interuct(bt):
    while True:
        if bt.poll() is not None:
            print("Error: bt exited with code " + str(bt.poll()))
            return
        restart_bt(bt)
        await_events(bt)


while True:
    # (yes/no):
    # ...
    bt = s.Popen(
        ["/usr/bin/bluetoothctl"],
        stdin=s.PIPE,
        stdout=s.PIPE,
        bufsize=1,
        encoding="utf-8"
    )
    try:
        bt_interuct(bt)
    except BTExitedException:
        print("BT exited, retrying in 2 seconds")
    time.sleep(2)

