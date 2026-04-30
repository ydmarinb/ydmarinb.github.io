#!/bin/bash

# build.sh - Static blog builder for ydmarinb.github.io
# Converts Jupyter notebooks to Markdown and generates a dynamic blog index
# Usage: ./build.sh

set -e

echo "🚀 Starting blog build process..."
echo "=================================="

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Define paths
NOTEBOOKS_DIR="./notebooks"
POSTS_DIR="./posts"
INDEX_FILE="./index_blog.html"
TEMP_INDEX=$(mktemp)

# Check if notebooks directory exists
if [ ! -d "$NOTEBOOKS_DIR" ]; then
    echo -e "${YELLOW}⚠️  Notebooks directory not found: $NOTEBOOKS_DIR${NC}"
    exit 1
fi

# Ensure posts directory exists
mkdir -p "$POSTS_DIR"

# Initialize the blog index file
echo "📝 Generating blog index..."

# Create a temporary Python script to generate the index
cat > /tmp/generate_index.py << 'EOF'
#!/usr/bin/env python3
import os
import json
from pathlib import Path
from datetime import datetime
import re
import subprocess

NOTEBOOKS_DIR = "./notebooks"
POSTS_DIR = "./posts"

def get_file_date(filepath):
    """Extract modification date from file."""
    timestamp = os.path.getmtime(filepath)
    return datetime.fromtimestamp(timestamp)

def capitalize_first_letter(text):
    """Capitalize only the first letter of the string."""
    if not text:
        return text
    return text[0].upper() + text[1:]

def get_notebook_title(notebook_path):
    # This logic matches scripts/get_title.py
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

def convert_notebook_to_markdown(nb_path, md_path):
    """Convert Jupyter notebook to Markdown using nbconvert."""
    try:
        cmd = [
            'python3', '-m', 'nbconvert',
            '--to', 'markdown',
            '--output-dir', os.path.dirname(md_path),
            '--output', os.path.basename(md_path),
            nb_path
        ]
        subprocess.run(cmd, check=True, capture_output=True)
        return True
    except Exception as e:
        print(f"Warning: Could not convert {nb_path}: {e}")
        return False

def extract_first_paragraph(md_path):
    """Extract first paragraph from markdown file for preview."""
    try:
        with open(md_path, 'r') as f:
            lines = f.readlines()
            for line in lines:
                line = line.strip()
                if line and not line.startswith('#'):
                    # Remove markdown syntax
                    line = re.sub(r'[*_`\[\]]', '', line)
                    return line[:150] + ('...' if len(line) > 150 else '')
    except:
        pass
    return "Click to read more..."

# Collect all posts with metadata
posts_by_category = {}

for category in os.listdir(NOTEBOOKS_DIR):
    category_path = os.path.join(NOTEBOOKS_DIR, category)
    if not os.path.isdir(category_path):
        continue
    
    posts_by_category[category] = []
    
    for root, _, files in os.walk(category_path):
        for file in files:
            if file.lower() == "description.md":
                continue
            if file.endswith('.ipynb'):
                nb_path = os.path.join(root, file)
                
                # Extract subtopic from relative path
                rel_path = os.path.relpath(root, category_path)
                if rel_path == '.' or not rel_path:
                    subtopic = "General"
                else:
                    subtopic_raw = rel_path.split(os.sep)[0]
                    subtopic = capitalize_first_letter(subtopic_raw.replace('-', ' ').replace('_', ' '))
                
                md_filename = file.replace('.ipynb', '.md')
                md_path = os.path.join(POSTS_DIR, f"{category}_{md_filename}")
                
                # Convert notebook to markdown
                print(f"Converting {file} from {root}...")
                if convert_notebook_to_markdown(nb_path, md_path):
                    # Get metadata
                    file_date = get_file_date(nb_path)
                    title = get_notebook_title(nb_path)
                    preview = extract_first_paragraph(md_path)
                    
                    posts_by_category[category].append({
                        'title': title,
                        'date': file_date,
                        'date_str': file_date.strftime('%B %d, %Y'),
                        'date_iso': file_date.isoformat(),
                        'path': f"posts/{category}_{md_filename}",
                        'preview': preview,
                        'category': category,
                        'subtopic': subtopic
                    })

# Sort posts by date (descending) within each category
for category in posts_by_category:
    posts_by_category[category].sort(key=lambda x: x['date'], reverse=True)

# Generate HTML
html_content = '''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Blog - Articles on Data Engineering, Statistics & Colombian History">
    <title>Blog - ydmarinb</title>
    <link rel="stylesheet" href="/assets/style.css">
    <script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
    <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/prismjs@1.29.0/themes/prism-tomorrow.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/prismjs@1.29.0/prism.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/prismjs@1.29.0/components/prism-python.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/prismjs@1.29.0/components/prism-sql.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/prismjs@1.29.0/components/prism-scala.min.js"></script>
</head>
<body>
    <header>
        <div class="container">
            <nav>
                <a href="/" class="logo">ydmarinb</a>
                <ul>
                    <li><a href="/">Home</a></li>
                    <li><a href="index_blog.html">Blog</a></li>
                    <li><a href="libros.html">Biblioteca</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <main>
        <div class="container">
            <section style="margin-bottom: 60px;">
                <h1>Blog</h1>
                <p style="font-size: 18px; color: #555; margin-bottom: 30px;">
                    Exploring data engineering, statistics, and Colombian history through analysis and visualization.
                </p>
            </section>

            <section class="posts-section">
'''

# Add categories and posts
category_order = ['ingenieria-datos', 'historia-colombia', 'libros', 'historia']
for cat in category_order:
    if cat in posts_by_category and posts_by_category[cat]:
        cat_display = capitalize_first_letter(cat.replace('-', ' ').replace('_', ' '))
        html_content += f'''
            <div class="category">
                <h2 class="category-title">{cat_display}</h2>
                <ul class="posts-list">
'''
        for post in posts_by_category[cat]:
            html_content += f'''
                    <li class="post-item">
                        <div>
                            <a href="{post['path']}" class="post-title">{post['title']}</a>
                            <p style="margin: 8px 0; color: #666; font-size: 14px;">{post['preview']}</p>
                        </div>
                        <span class="post-date">{post['date_str']}</span>
                    </li>
'''
        html_content += '''
                </ul>
            </div>
'''

html_content += '''
            </section>
        </div>
    </main>

    <footer>
        <div class="container">
            <p>&copy; 2026 ydmarinb. All rights reserved.</p>
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            Prism.highlightAll();
        });
    </script>
</body>
</html>
'''

# Write the index file
with open('./index_blog.html', 'w') as f:
    f.write(html_content)

print("✅ Blog index generated successfully!")
print(f"📊 Posts processed: {sum(len(posts) for posts in posts_by_category.values())}")
EOF

# Run the Python script to generate the index
python3 /tmp/generate_index.py

# Clean up
rm /tmp/generate_index.py

echo ""
echo -e "${GREEN}✅ Build process completed successfully!${NC}"
echo ""
echo -e "${BLUE}📁 Output files:${NC}"
echo "   - Posts (Markdown): ./posts/"
echo "   - Blog Index: ./index_blog.html"
echo ""
echo -e "${BLUE}🌐 Next steps:${NC}"
echo "   1. Open ./index_blog.html in your browser to preview"
echo "   2. Push changes to GitHub to trigger the deploy workflow"
echo ""