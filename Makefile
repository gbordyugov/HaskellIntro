all: day01.html day02.html day03.html day04.html

day01.html: day01.md style.css Makefile
day02.html: day02.md style.css Makefile
day03.html: day03.md style.css Makefile
day04.html: day04.md style.css Makefile

.SUFFIXES: .md .html

.md.html:
	pandoc -A style.css -f markdown+lhs -s --webtex -t dzslides $< -o $@
