all: day01.html day02.html

day01.html: day01.md style.css Makefile
day02.html: day02.md style.css Makefile

.SUFFIXES: .md .html

.md.html:
	pandoc -A style.css -f markdown+lhs -s --webtex -t dzslides $< -o $@
