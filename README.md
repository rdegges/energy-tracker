# energy-tracker

A simple script (meant to be run via cron) that tracks your Mac laptop's energy usage in watt hours.

**NOTE**: This will only run on Mac.


## Installation

To start, copy the energy tracking script into the correct folder:

```bash
cp log-power-usage.sh /usr/local/bin/log-power-usage.sh
```

Next, install the cron script which will run the energy tracker once per minute:

```bash
crontab -l > cron-new
cat cron >> cron-new
crontab cron-new
rm cron-new
```


## Viewing Usage Data

Once installed, the energy tracker will log all energy consumption to the file `~/Library/Caches/energy-tracker/energy-log.txt`.

This file will look something like this:

```text
timestamp=2022-01-20T05:48:00Z wattage=9.13724327 wattHours=.15228738783333333333 uuid=9D1166AE-BAC5-52CB-976C-B86196AC744D
timestamp=2022-01-20T05:49:00Z wattage=7.54702139 wattHours=.12578368983333333333 uuid=9D1166AE-BAC5-52CB-976C-B86196AC744D
timestamp=2022-01-20T05:50:01Z wattage=7.04053497 wattHours=.11734224950000000000 uuid=9D1166AE-BAC5-52CB-976C-B86196AC744D
timestamp=2022-01-20T05:51:00Z wattage=7.21910381 wattHours=.12031839683333333333 uuid=9D1166AE-BAC5-52CB-976C-B86196AC744D
```

Each line contains a timestamp, the amount of wattage being used at the time of sampling, the amount of watt-hours being used, and the uuid of the Mac.
