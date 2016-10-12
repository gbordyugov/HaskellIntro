all: day01.html

.SUFFIXES: .md .html

.md.html:
	pandoc -A style.css -f markdown+lhs -s --webtex -t dzslides $< -o $@
