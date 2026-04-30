import sys
import json
from pathlib import Path

def get_title(notebook_path):
    title = ""
    filename = Path(notebook_path).stem
    try:
        with open(notebook_path, 'r', encoding='utf-8') as f:
            nb = json.load(f)
            if 'metadata' in nb and 'title' in nb['metadata']:
                title = nb['metadata']['title']
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
            clean_title = clean_title[0].upper() + clean_title[1:].lower()
            
        prefix = ""
        suffix = ""
        if has_open_e: prefix += "¡"
        if has_open_q: prefix += "¿"
        if has_close_q: suffix += "?"
        if has_close_e: suffix += "!"
        
        title = prefix + clean_title + suffix
    else:
        title = title.replace('-', ' ').replace('_', ' ')
        if title:
            title = title[0].upper() + title[1:].lower()
            
    return title

if __name__ == "__main__":
    if len(sys.argv) > 1:
        print(get_title(sys.argv[1]))
