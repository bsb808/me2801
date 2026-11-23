# Step input for ME2801 Lab 2. Runs inside Mission Planner (DATA -> Scripts),
# which supplies the Script object. It will not run from a normal Python prompt.
import time

# Student settings
DURATION_SECONDS = 30
CHANNEL = 3
PWM = 1550

# Start timer
end_time = time.time() + DURATION_SECONDS
print("Step start: channel %d at %d PWM for %d s" % (CHANNEL, PWM, DURATION_SECONDS))

try:
    while time.time() < end_time:
        Script.SendRC(CHANNEL, PWM, True)
        Script.Sleep(100)

finally:
    # Release RC override (0 = return channel to the transmitter)
    Script.SendRC(CHANNEL, 0, True)
    print("Step end: channel %d released" % CHANNEL)
