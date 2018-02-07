# Makefile for the CSC 7101 Verification Condition Generator

MAIN = VCG
LANG = IMP
PDIR = Parse
TDIR = Tree
START= program

JFLAG= -g
ANTLR= java -jar antlr-4.6-complete.jar
GRUN = java org.antlr.v4.gui.TestRig

all: antlr
	javac ${JFLAG} ${MAIN}.java ${PDIR}/${LANG}*.java ${TDIR}/*.java

antlr: ${PDIR}/${LANG}.g4
	(cd ${PDIR}; ${ANTLR} ${LANG}.g4)

test: test.vcg
	${GRUN} ${PDIR}.${LANG} ${START} -gui test.vcg

clean:
	rm -f *.class *~ ${TDIR}/*.class ${TDIR}/*~
	(cd ${PDIR}; rm -f ${LANG}*.java ${LANG}*.tokens *.class *~)
