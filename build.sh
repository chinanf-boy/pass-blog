git add . && git commit -m "blog: +"
hugo -b "/pass-blog/" -d "docs"
git add . && git commit -m "docs: +"
git push
node ~/cpDocs.js "./docs"