# Setup & publishing guide

A one-time checklist to get this repository online and the report live on
GitHub Pages.

## 0. Before you push — clean-up checklist
- [ ] Add the thesis PDF as `report/TFG_Iglesias_Garcia.pdf`.
- [ ] Confirm no personal data or local paths are committed (the raw/coded data
      files are already git-ignored; scripts use relative paths).
- [ ] In `_quarto.yml` and `README.md`, replace `YOUR_USERNAME` with your GitHub
      handle.

## 1. Put the project under version control
```bash
cd gamification-math-apps-analysis
git init
git add .
git commit -m "Initial commit: TFG gamification analysis (R + Quarto)"
```

## 2. Create the GitHub repository and push
Create an **empty** public repo on GitHub named
`gamification-math-apps-analysis` (no README/License — this repo has them), then:
```bash
git remote add origin https://github.com/YOUR_USERNAME/gamification-math-apps-analysis.git
git branch -M main
git push -u origin main
```

## 3. Publish the report to GitHub Pages

**Option A — automatic (recommended, no local render).**
The included Action (`.github/workflows/publish.yml`) renders `index.qmd` and
pushes the site to a `gh-pages` branch on every push to `main`. After the first
run finishes:
1. Repo → **Settings → Pages**.
2. **Source:** *Deploy from a branch* → Branch **`gh-pages`** → **/(root)** → Save.
3. Wait ~1 min; your site is at
   `https://YOUR_USERNAME.github.io/gamification-math-apps-analysis/`.

**Option B — one command from your machine** (needs Quarto installed):
```bash
quarto publish gh-pages
```
This renders locally and pushes to `gh-pages` in one step.

## 4. (Optional) run the full analysis
```r
# Open the project at its root, then:
source("R/00_run_all.R")
```
Add the data files first (see `data/README.md`). Scripts 03 and 04 need the extra
coding files; comment them out in `00_run_all.R` if you don't have them — the
modelling chain 05→13 does not depend on them.

## 5. Amplify it for job applications
- Add the repo and the live report link to **LinkedIn** (Projects section).
- Pin the repo on your GitHub profile.
- Link it in your CV and cover letters (great fit for data-analyst roles).
- Optionally publish a notebook version on **Kaggle** and deposit the thesis in the
  **URJC institutional repository**.
