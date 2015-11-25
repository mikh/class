################ CHANGELOG #####################
#
# v0.0 - 5/21/15 10:13 Initial version. Designed to provide basic console output controls
# v0.1 - 5/21/15 10:42 Added progress bar function 
#
################ END CHANGELOG ################

import time, sys

#### PRIVATE FUNCTIONS ####

PROGRESS_BAR_LENGTH_IN_CHARS = 50



#### PUBLIC FUNCTIONS ####

def update_progress_bar(percentage, label):
	chars_used = int(float(PROGRESS_BAR_LENGTH_IN_CHARS)*percentage)
	sys.stdout.write("\r[{0}{1}] {2:.2f}%: {3}".format(("="*chars_used).replace("\n",""), (" "*(PROGRESS_BAR_LENGTH_IN_CHARS-chars_used)).replace("\n",""), percentage*100, label))
	sys.stdout.flush()



#### TEST CODE ####
'''
for i in range(100):
    time.sleep(1)
    update_progress_bar(float(i)/100.0, str(i))
'''