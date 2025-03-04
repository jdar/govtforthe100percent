import requests
from bs4 import BeautifulSoup
import csv
import string
import time
import re

base_url = 'https://www.usa.gov/agency-index'


def extract_agencies(letter):
    """
    Extracts agency name and website from the letter-specific page.
    Only agencies with a valid 'Website:' field are included.
    If an agency name includes an accepted acronym in parentheses,
    it is retained in the name.
    """
    url = f'{base_url}/{letter}'
    print(f"Processing: {url}")
    response = requests.get(url)
    if response.status_code != 200:
        print(f"Failed to retrieve {url}")
        return []

    soup = BeautifulSoup(response.content, 'html.parser')
    agencies = []

    # Find all header tags that may denote agency names (adjust if necessary)
    # We assume agency names appear in h2 or h3 tags.
    headers = soup.find_all(['h2', 'h3'])
    for header in headers:
        agency_name = header.get_text(strip=True)
        # Skip single-letter headings (the letter index)
        if len(agency_name) == 1 and agency_name.isalpha():
            continue

        # Walk through the siblings after the header to locate the "Website:" field.
        website = None
        sibling = header.find_next_sibling()
        while sibling:
            # Look for the text "Website:" in this block.
            if "Website:" in sibling.get_text():
                # Find the first link whose href starts with "http"
                a_tag = sibling.find('a', href=True)
                if a_tag and a_tag['href'].startswith('http'):
                    website = a_tag['href']
                    break
            sibling = sibling.find_next_sibling()

        # Only add if we found a website.
        if website:
            # Optionally, check if an acronym exists within parentheses in the agency name.
            # If not, you might consider additional extraction logic here.
            # For now, we assume the heading already includes the acronym when applicable.
            agencies.append((agency_name, website))

    return agencies


all_agencies = []

# "A"
agencies = extract_agencies("")
print(f"Found {len(agencies)} agencies for letter A")
all_agencies.extend(agencies)

# B-Z
for letter in string.ascii_uppercase:
    agencies = extract_agencies(letter)
    print(f"Found {len(agencies)} agencies for letter {letter}")
    all_agencies.extend(agencies)
    time.sleep(1)  # polite delay between requests

print(f"Total agencies found: {len(all_agencies)}")

# Save the results to a CSV file.
with open('us_agencies.csv', 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['Agency Name', 'Website'])
    writer.writerows(all_agencies)

print("Data saved to 'us_agencies.csv'.")
