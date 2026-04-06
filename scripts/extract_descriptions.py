import os
import json

NOTEBOOKS_DIR = "notebooks"
OUT_FILE = "_data/descriptions.json"

desc_dict = {}

def format_subtopic(raw):
    raw = raw.replace('-', ' ').replace('_', ' ')
    words = raw.split()
    return ' '.join([w[0].upper() + w[1:] if w else '' for w in words])

if os.path.exists(NOTEBOOKS_DIR):
    for root, dirs, files in os.walk(NOTEBOOKS_DIR):
        for file in files:
            if file.lower() == "description.md":
                filepath = os.path.join(root, file)
                rel_dir = os.path.relpath(root, NOTEBOOKS_DIR)
                
                parts = rel_dir.split(os.sep)
                if len(parts) == 1 and parts[0] != ".":
                    top_cat = parts[0]
                    subtopic = "General"
                elif len(parts) > 1:
                    top_cat = parts[0]
                    subtopic_raw = parts[1]
                    subtopic = format_subtopic(subtopic_raw)
                else:
                    continue
                
                with open(filepath, "r", encoding="utf-8") as f:
                    content = f.read().strip()
                
                if top_cat not in desc_dict:
                    desc_dict[top_cat] = {}
                desc_dict[top_cat][subtopic] = content

os.makedirs(os.path.dirname(OUT_FILE), exist_ok=True)
with open(OUT_FILE, "w", encoding="utf-8") as f:
    json.dump(desc_dict, f, ensure_ascii=False, indent=2)

print(f"Descriptions extracted to {OUT_FILE} successfully!")
