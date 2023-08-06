# Scripts to ask questions about your Git repository and GitLab issues.

## What is it?

* Ask questions about some features
* Ask to write a checklist for a feature
* Ask to write a git commit message for code diff

## How it works?

- MongoDB to save dev documents:
    - Issues for GitLab issues
    - Commits for Git commits
- Chroma database to save documents with embeddings and query documents by embeddings
- ChatGTP to generate embeddings and ask questions
