all: day01.html

.SUFFIXES: .md .html

.md.html:
	pandoc -f markdown+lhs -s --webtex -t dzslides $< -o $@
