git add . && git commit -m "blog: +"
hugo -b "/pass-blog/" -d "docs"
node ~/cpDocs.js "./docs"