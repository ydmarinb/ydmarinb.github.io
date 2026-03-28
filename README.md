# ydmarinb.github.io - Personal Blog

A professional static blog built with Jupyter notebooks, automated with Python scripts, and deployed via GitHub Actions. Featuring data engineering articles, statistical analysis, and Colombian history explorations.

## 🎯 Features

- **Notebook-Driven**: Write posts as Jupyter notebooks (`.ipynb`)
- **Automated Conversion**: Jupyter notebooks → Markdown → HTML via `build.sh`
- **Dynamic Blog Index**: Automatic post discovery, categorization, and date sorting
- **Professional Design**: Minimalist aesthetic with Prussian blue accents (#003366)
- **Math Support**: MathJax for rendering LaTeX equations
- **Code Highlighting**: Prism.js for syntax highlighting (Python, SQL, Scala)
- **CI/CD Ready**: GitHub Actions automatically deploys on push to master
- **Responsive Design**: Mobile-friendly layout

## 📁 Project Structure

```
ydmarinb.github.io/
├── index.html                      # Landing page (Home)
├── index_blog.html                 # Auto-generated blog index
├── build.sh                        # Build script (converts notebooks)
├── assets/
│   └── style.css                   # Minimalista professional CSS
├── notebooks/                      # Source of truth
│   ├── estadistica/                # Statistics posts
│   │   └── introduction-to-statistical-distributions.ipynb
│   ├── ingenieria-datos/           # Data engineering posts
│   └── historia-colombia/          # Colombian history posts
├── posts/                          # Generated markdown files (output)
└── .github/workflows/
    └── deploy.yml                  # GitHub Actions CI/CD pipeline
```

## 🚀 Quick Start

### 1. Prerequisites

Ensure you have the following installed:

```bash
# Python 3.11+
python --version

# macOS (Homebrew)
brew install python jupyter pandoc

# Linux (Ubuntu/Debian)
sudo apt-get install python3 python3-pip pandoc
sudo pip install jupyter nbconvert
```

### 2. Clone and Set Up

```bash
# Clone the repository
git clone https://github.com/ydmarinb/ydmarinb.github.io.git
cd ydmarinb.github.io

# Install Python dependencies
pip install --upgrade pip
pip install jupyter nbconvert
```

### 3. Build Locally

```bash
# Make build script executable
chmod +x build.sh

# Run the build process
./build.sh
```

The script will:
- ✅ Scan all `.ipynb` files in `/notebooks/` subdirectories
- ✅ Convert them to Markdown using `jupyter nbconvert`
- ✅ Extract file dates automatically
- ✅ Generate `index_blog.html` with posts organized by category
- ✅ Output Markdown files to `/posts/`

### 4. Preview Locally

```bash
# Option 1: Simple HTTP server (Python 3)
python3 -m http.server 8000

# Option 2: Using Live Server extension in VS Code
# Install "Live Server" extension, then right-click index.html → "Open with Live Server"
```

Then open: `http://localhost:8000`

## 📝 Writing Blog Posts

### 1. Create a Notebook

Create a new Jupyter notebook in the appropriate category:

```bash
# Example: New data engineering post
touch notebooks/ingenieria-datos/my-new-post.ipynb

# Or use Jupyter UI
jupyter notebook notebooks/ingenieria-datos/
```

### 2. Add Metadata (Optional)

For better control, add metadata to your notebook:

```json
{
  "metadata": {
    "title": "My Custom Post Title",
    "author": "Your Name",
    "date": "2026-03-27"
  }
}
```

### 3. Write Content

Use standard Jupyter cells:
- **Markdown cells** for text, headers, and equations
- **Code cells** for Python, SQL, Scala examples
- **Math support**: LaTeX equations with `$$...$$` (block) or `$...$` (inline)

Example:

```markdown
# Post Title

## Mathematics Example

The normal distribution:
$$f(x) = \frac{1}{\sigma\sqrt{2\pi}} e^{-\frac{(x-\mu)^2}{2\sigma^2}}$$

## Code Example

```python
import pandas as pd
df = pd.read_csv('data.csv')
print(df.head())
```
```

### 4. Build and Test

```bash
./build.sh
```

Check the generated `posts/` and `index_blog.html`

## 🔧 Advanced Configuration

### Customize CSS

Edit `assets/style.css` to modify:
- Colors (Prussian blue `#003366`)
- Typography (Inter/Roboto font family)
- Responsive breakpoints
- MathJax and Prism.js styling

### Modify Build Script

The `build.sh` script uses a Python generator for flexibility. Edit the Python section for:
- Category ordering
- Date formatting
- Post preview length
- HTML template structure

### Add New Categories

1. Create a new subdirectory in `notebooks/`:
   ```bash
   mkdir notebooks/mi-nueva-categoria
   ```

2. Add notebooks there
3. Run `./build.sh`
4. Update category order in `build.sh` (Python section) if needed

## 🚀 Deployment

### GitHub Pages Automatic Deployment

The repository includes GitHub Actions CI/CD. On every push to `master` branch:

1. ✅ GitHub Actions checks out code
2. ✅ Installs Python 3.11 + dependencies
3. ✅ Runs `./build.sh` 
4. ✅ Deploys to GitHub Pages (`gh-pages` branch)

**No manual deployment needed!** Just push your changes:

```bash
git add .
git commit -m "Add new blog post"
git push origin master
```

View workflow status: https://github.com/ydmarinb/ydmarinb.github.io/actions

### Manual Deployment

If needed, manually build and commit:

```bash
./build.sh
git add posts/ index_blog.html
git commit -m "Update blog posts"
git push origin master
```

## 📚 Example Post

A sample post is included: `notebooks/estadistica/introduction-to-statistical-distributions.ipynb`

It demonstrates:
- LaTeX mathematical equations
- Python code execution
- matplotlib visualizations
- SQL code examples
- Prism.js syntax highlighting

Build and view it:

```bash
./build.sh
# Open index_blog.html in browser and click the post
```

## 🎨 Design Specifications

### Color Scheme
- **Primary**: Prussian Blue `#003366`
- **Background**: Pure White `#ffffff`
- **Text**: Dark Gray `#1a1a1a`
- **Accents**: Light Gray `#f8f9fa`

### Typography
- **Headers**: Sans-serif (Inter, Roboto, system)
- **Body**: Sans-serif (Inter, Roboto, system)
- **Code**: Monospace (Monaco, Menlo, Ubuntu Mono)
- **Line Height**: 1.6
- **Max Width**: 900px

### Responsive Design
- Desktop: Full width (up to 900px container)
- Tablet/Mobile: 768px breakpoint with adjusted typography

## 📋 Troubleshooting

### Issue: `jupyter nbconvert not found`

**Solution:**
```bash
pip install jupyter nbconvert --upgrade
```

### Issue: `pandoc not found` (optional)

**Solution:**
```bash
# macOS
brew install pandoc

# Ubuntu/Debian
sudo apt-get install pandoc
```

### Issue: Build script fails

**Solution:** Make sure script is executable:
```bash
chmod +x build.sh
./build.sh
```

### Issue: Notebooks not converted

**Solution:** Ensure notebooks are in correct structure:
```bash
ls notebooks/estadistica/
# Should show: introduction-to-statistical-distributions.ipynb
```

### Issue: GitHub Pages not updating

**Solution:** Check Actions tab in GitHub repo:
1. Go to: https://github.com/ydmarinb/ydmarinb.github.io/actions
2. Check if workflow succeeded
3. Verify `gh-pages` branch exists
4. Check GitHub Pages settings point to `gh-pages` branch

## 📞 Support

- **Jupyter Documentation**: https://jupyter.org/
- **nbconvert Guide**: https://nbconvert.readthedocs.io/
- **GitHub Pages**: https://pages.github.com/
- **MathJax**: https://www.mathjax.org/
- **Prism.js**: https://prismjs.com/

## 📄 License

This project is open source and available under the MIT License.

---

**Built with ❤️ | Jupyter + Python + GitHub Actions**
   open index.html
   ```

## GitHub Actions
- The blog is automatically deployed to GitHub Pages when changes are pushed to the `master` branch.
- The workflow file `.github/workflows/deploy.yml` handles the deployment process.

## Adding New Posts
1. Place your Jupyter notebooks in the appropriate subfolder under `/notebooks` (e.g., `/notebooks/estadistica`).
2. Run the build script to update the blog index:
   ```bash
   ./build.sh
   ```
3. Commit and push your changes to trigger the deployment.

## Features
- Minimalist design with responsive layout.
- Support for MathJax (for equations) and Prism.js (for code syntax highlighting).
- Automated conversion of Jupyter notebooks to markdown.
- Dynamic blog index generation.
