from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver import Firefox
from selenium.webdriver.firefox.service import Service
from selenium.webdriver.firefox.options import Options
import time
import sys
import argparse
import os

try:
	kw = str(sys.argv[1])
except:
	print("Add a keyword, dummy!")
	print("Example: python", os.path.basename(__file__), "\"keyword\"")
	sys.exit(1)

#print("Keyword:", keyword)

# Form Info
em = "test.data@imfrench.co.fr"
fn = "Francois"
ln = "Frenchman"
pn = "9185551234"

# Browser Setup
options = webdriver.FirefoxOptions()
options.set_preference("geo.prompt.testing", True)
options.set_preference("geo.prompt.testing.allow", False)
driver = webdriver.Firefox(options=options)

driver.get("https://edgetulsa.com/contests/hawaiitripgiveaway/")
#time.sleep(3);

# Fill Form Fields
first_name = driver.find_element(By.ID, "input_398_1_3")
first_name.click();
first_name.send_keys(fn);

last_name = driver.find_element(By.ID, "input_398_1_6")
last_name.click();
last_name.send_keys(ln);

email = driver.find_element(By.ID, "input_398_2")
email.click();
email.send_keys(em);

email2 = driver.find_element(By.ID, "input_398_2_2")
email2.click();
email2.send_keys(em);

phone = driver.find_element(By.ID, "input_398_10")
phone.click();
phone.send_keys(pn);

keyword = driver.find_element(By.ID, "input_398_9")
keyword.click();
keyword.send_keys(kw);

checkbox = driver.find_element(By.ID, "input_398_5_1").click()

# Send it
driver.find_element(By.ID, "gform_submit_button_398").click()

time.sleep(3)
driver.quit()

