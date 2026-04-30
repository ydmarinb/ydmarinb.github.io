import sys
import json
from pathlib import Path

def get_title(notebook_path):
    title = ""
    filename = Path(notebook_path).stem
    try:
        with open(notebook_path, 'r', encoding='utf-8') as f:
            nb = json.load(f)
            if 'metadata' in nb:
                if 'title' in nb['metadata']:
                    title = nb['metadata']['title']
                elif 'book_title' in nb['metadata'] and 'author' in nb['metadata']:
                    title = f"{nb['metadata']['book_title']}  {nb['metadata']['author']}"
    except:
        pass
        
    if not title:
        title = filename.replace('-', ' ').replace('_', ' ')
        
        has_open_q = '[' in title
        has_close_q = ']' in title
        has_open_e = '<' in title
        has_close_e = '>' in title
        
        clean_title = title.replace('[', '').replace(']', '').replace('<', '').replace('>', '').strip()
        
        if clean_title:
            # For filename-based titles, lowercase everything except the first letter
            clean_title = clean_title[0].upper() + clean_title[1:].lower()
            
        prefix = ""
        suffix = ""
        if has_open_e: prefix += "¡"
        if has_open_q: prefix += "¿"
        if has_close_q: suffix += "?"
        if has_close_e: suffix += "!"
        
        title = prefix + clean_title + suffix
    else:
        # For metadata-based titles, keep the casing as defined in metadata
        title = title.replace('-', ' ').replace('_', ' ')
        if title:
            title = title[0].upper() + title[1:]
            
    return title

if __name__ == "__main__":
    if len(sys.argv) > 1:
        print(get_title(sys.argv[1]))
