# ydmarinb.github.io - Advanced Analytics & History Microsite Platform

A robust, fully automated static blog built natively with **Jekyll**, driven by **Jupyter Notebooks**, and orchestrated by a highly customized **GitHub Actions** CI/CD pipeline. The platform is architected into three distinct microsites, providing custom academic layouts, dynamic indexing, and zero-maintenance deployment.

## 🎯 Platform Features

- **"Zero-Maintenance" Publishing**: Write your posts directly as Jupyter notebooks (`.ipynb`) in specific directories. The system handles the rest.
- **Smart Directory Routing**: Notebooks placed in specific directories (`historia-colombia`, `ingenieria-datos`, etc.) are automatically assigned to their respective microsite ecosystems and formatted with appropriate dates and metadata.
- **Three Core Microsites**:
  - **Historia**: A classical, serif-font ecosystem focused on Colombian History. Features localized Spanish date formats and a dark-red academic theme.
  - **Statistics**: Features native KaTeX/MathJax support for advanced probabilistic models and high-quality equation rendering.
  - **Data Engineering**: Focused on robust data infrastructure with deep-dark code styling and custom syntax highlights for Python/SQL/Scala.
- **Hybrid Rendering Engines**: 
  - *MathJax*: Seamless `LaTeX` execution across all articles.
  - *PrismJs*: Custom syntax highlighting and dark-theming for native code blocks.
- **CI/CD Ready**: The custom GitHub Actions pipeline (`deploy.yml`) handles everything from `nbconvert` processing to dynamic frontmatter injection upon every push to the `main` branch.

## 📁 Repository Architecture

```text
ydmarinb.github.io/
├── index.html                      # Main landing page (Router Interface)
├── _config.yml                     # Jekyll engine configuration & collections
├── assets/
│   └── style.css                   # Global CSS tokens and variables
├── _layouts/                       # Microsite specific templates
│   ├── historia.html               # Merriweather Serif layout
│   └── data.html                   # Monaco/Fira Code developer layout
├── notebooks/                      # SOURCE OF TRUTH (Your workspace)
│   ├── estadistica/                # Target -> Statistics Microsite
│   ├── ingenieria-datos/           # Target -> Data Engineering Microsite
│   └── historia-colombia/          # Target -> History Microsite
└── .github/workflows/
    └── deploy.yml                  # The CI/CD engine that runs the magic
```

## 🚀 How to Publish a Post (Workflow)

The platform is completely decoupled from Jekyll configuration. As a writer, you only interact with Jupyter Notebooks.

### 1. Write your Notebook
Create standard Jupyter `.ipynb` notebooks locally using your editor of choice. You can combine Markdown, `$$LaTeX$$` equations, and Python code blocks.

### 2. Save into a Category Directory
Place your notebook directly into one of the designated folders inside `notebooks/`.

```bash
# For a History article:
notebooks/historia-colombia/my_article.ipynb

# For a Statistics mathematical analysis:
notebooks/estadistica/understanding_poisson.ipynb

# For Data Engineering architecture:
notebooks/ingenieria-datos/etl_pipeline_design.ipynb
```

### 3. Push to GitHub
Simply add your files and push to `main`:

```bash
git add notebooks/
git commit -m "feat: added new poisson distribution analysis"
git push origin main
```

**That's it.** The GitHub Action will immediately boot up, convert the `.ipynb` file to Markdown, inject the current system date via shell commands into the frontmatter, dispatch the markdown file to the hidden Jekyll collection folders (`_historia`, `_statistics`, `_datos`), extract image assets, compile the Jekyll site natively, and deploy the new index layouts automatically.

## 🎨 Theme & Technical Stack

- **Code Engine**: Customized `PrismJS` loaded globally with a dark-node contrast theme for readability against white backgrounds.
- **Math Engine**: Deep `MathJax 3.0` polyfill integration resolving `$..$` and `\[..\]` blocks.
- **Frontend Logic**: Liquid Templating algorithms looping dynamically over native `site.collections`, reversing chronologically based on auto-injected Frontmatter dates.

## 📋 Troubleshooting Operations

If a notebook does not appear after waiting 90 seconds for GitHub Actions to compile:
- **Routing Issue**: Ensure the folder you placed the notebook inside matches the Bash evaluation criteria in `.github/workflows/deploy.yml` (e.g., contains the word "historia", "estadistica", "ingenieria", or "data").
- **Jekyll Cache**: Clear browser cache or ensure the CI/CD pipeline finished successfully in the "Actions" tab of GitHub.

## 📄 License

This open-source micro-publishing architecture is provided under the MIT License. Built with ❤️ utilizing Jupyter, GitHub Actions & Jekyll.
