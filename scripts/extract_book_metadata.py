#!/usr/bin/env python3
"""Extract book_title and author from a notebook filename.

Convention: The filename uses double dash (--) to separate book title from author.
Example: La-mente-de-los-justos--Jonathan-Haidt.ipynb
         -> book_title: "La mente de los justos"
         -> author: "Jonathan Haidt"

If no double dash is found, the whole filename becomes the title and author is empty.
"""
import sys
import os

def main():
    if len(sys.argv) < 3:
        print("Usage: extract_book_metadata.py <notebook_path> <field>")
        print("  field: 'book_title' or 'author'")
        sys.exit(1)
    
    nb_path = sys.argv[1]
    field = sys.argv[2]  # 'book_title' or 'author'
    
    # Get filename without extension
    basename = os.path.basename(nb_path)
    name_no_ext = os.path.splitext(basename)[0]
    
    if '--' in name_no_ext:
        parts = name_no_ext.split('--', 1)
        book_title = parts[0].replace('-', ' ').strip()
        author = parts[1].replace('-', ' ').strip()
    else:
        book_title = name_no_ext.replace('-', ' ').replace('_', ' ').strip()
        author = ''
    
    if field == 'book_title':
        print(book_title)
    elif field == 'author':
        print(author)
    else:
        print('')

if __name__ == '__main__':
    main()