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
em = "baguette@eifeltower.co.fr"
fn = "Pierre"
ln = "Francois"
pn = "9185551234"

# Element Names
Efn = "input_1.3"
Eln = "input_1.6"
Eem = "input_2"
Eem2 = "input_2_2"
Epn = "input_10"
Ekw = "input_9"
Ecb = "input_5.1"

# Browser Setup
options = webdriver.FirefoxOptions()
options.set_preference("geo.prompt.testing", True)
options.set_preference("geo.prompt.testing.allow", False)
driver = webdriver.Firefox(options=options)

driver.get("https://edgetulsa.com/contests/hawaiitripgiveaway/")
time.sleep(3);

# Fill Form Fields
first_name = driver.find_element(By.NAME, Efn)
driver.execute_script('arguments[0].scrollIntoView();', first_name);
first_name.click();
first_name.send_keys(fn);

last_name = driver.find_element(By.NAME, Eln)
last_name.click();
last_name.send_keys(ln);

email = driver.find_element(By.NAME, Eem)
email.click();
email.send_keys(em);

email2 = driver.find_element(By.NAME, Eem2)
email2.click();
email2.send_keys(em);

phone = driver.find_element(By.NAME, Epn)
phone.click();
phone.send_keys(pn);

keyword = driver.find_element(By.NAME, Ekw)
keyword.click();
keyword.send_keys(kw);

checkbox = driver.find_element(By.NAME, Ecb).click()

# Send it
driver.find_element(By.ID, "gform_submit_button_398").click()

time.sleep(3)
driver.quit()

