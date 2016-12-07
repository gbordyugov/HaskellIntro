all: day01.html day02.html day03.html day04.html day05.html day06.html \
     day07.html

day01.html: day01.md style.css Makefile
day02.html: day02.md style.css Makefile
day03.html: day03.md style.css Makefile
day04.html: day04.md style.css Makefile
day05.html: day05.md style.css Makefile
day06.html: day06.md style.css Makefile
day07.html: day07.md style.css Makefile

.SUFFIXES: .md .html

.md.html:
	pandoc -A style.css -f markdown+lhs -s --webtex -t dzslides $< -o $@
