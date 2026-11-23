import time

# Student settings
DURATION_SECONDS = 30
CHANNEL = 3
PWM = 1550

# Start timer
end_time = time.time() + DURATION_SECONDS

try:
    while time.time() < end_time:
        Script.SendRC(CHANNEL, PWM, True)
        Script.Sleep(100)

finally:
    # Release RC override
    Script.SendRC(CHANNEL, 0, True)
