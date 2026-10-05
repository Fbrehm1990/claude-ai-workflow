---
name: docs-task
description: Create or transform documents, spreadsheets and data files unattended. Use for [docs] tasks.
---

# Docs, data and files

1. Identify the inputs (paths named in the task, or earlier outputs in `outputs/`) and the format wanted.
   If no format is given, write Markdown.
2. **Never modify the originals.** Read them, and write the new files to `outputs/docs/YYYY-MM-DD-<slug>.<ext>`.
3. Use the right tool for the format: the docx, xlsx, pptx and pdf skills when they are available, or Python
   (pandas, openpyxl, python-docx) for data work. Install missing Python packages with `pip install --user`.
4. Data work: report the row counts before and after, the rules applied, and any rows dropped or flagged.
5. Check the result: open or parse the output file to confirm it is valid and complete.
6. Write a short `outputs/docs/YYYY-MM-DD-<slug>.notes.md` listing the inputs, what was done, and any assumptions.
