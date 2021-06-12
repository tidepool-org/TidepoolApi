# Incorrect Assumptions About Diabetes Device Times

* The display time on a [PwD's](./glossary.md#pwd) device will be accurate to their local time
* The display time will only be off by a few minutes
* The display time must be an hour off because of a [DST](./glossary.md#dst) changeover
* The user will remember to change the display time before the next DST changeover
* The display time on a PwD's device will always be the correct month
* The display time will always be the correct year
* The display time will not be set to a future date
* The display time on a PwD's device will not be January 1st, 2007 or January 1st, 2008 if the user got the device in 2015**
* Two (or more) events will not share the exact same [datetime](./glossary.md#datetime)
* If a stored time field on the events from a diabetes device looks like a [Unix time](./glossary.md#unix-time), it is a Unix time

**These are the two most common "default" times on diabetes devices. These default times surface on events under various circumstances, the most common of which is a clock error due to extended lack of power to the device (dead battery or battery out too long).
