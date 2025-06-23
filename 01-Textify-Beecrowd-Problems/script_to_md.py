from bs4 import BeautifulSoup
import glob
import os
import html2text

# Initialize HTML to Markdown converter
converter = html2text.HTML2Text()
converter.ignore_links = False
converter.body_width = 0

# Get all HTML files
html_files = glob.glob("*.html")

for filename in html_files:
    try:
        with open(filename, "r", encoding="utf-8") as file:
            html_content = file.read()

        soup = BeautifulSoup(html_content, "html.parser")

        # Extract the <h1> from the entire page
        h1 = soup.find("h1")
        h1_text = h1.get_text(strip=True) if h1 else "(No title)"

        # Extract the div with class "problem-sql"
        div_content = soup.find("div", class_="problem-sql")

        if div_content:
            # Convert div HTML to Markdown
            markdown = converter.handle(str(div_content)).strip()

            # Prepend the h1 as a Markdown header
            final_md = f"# {h1_text}\n\n{markdown}"

            # Prepare output filename
            base_name = os.path.splitext(filename)[0]
            output_file = f"problem-sql-md/{base_name}_problem_sql.md"

            with open(output_file, "w", encoding="utf-8") as out:
                out.write(final_md)

            print(f"Saved {output_file}")
        else:
            print(f"'problem-sql' div not found in {filename}")

    except Exception as e:
        print(f"Error processing {filename}: {e}")