# Makefile for the CSC 7101 Verification Condition Generator

MAIN = VCG
LANG = IMP
PDIR = Parse
TDIR = Tree
START= program
EXE  = VCG.jar
JAR  = VCG.class Parse/*.class Parse/*.tokens Tree/*.class javax org

# Change CPSEP to ; on Windows
CPSEP= :
ANTLR= antlr-4.7.1-complete.jar

ARUN = java -jar ${ANTLR}
GRUN = java -cp ".${CPSEP}${PDIR}/${ANTLR}" org.antlr.v4.gui.TestRig
JFLAG= -g -cp ${PDIR}/${ANTLR}

jar: clean all
	mkdir tmp
	(cd tmp; jar xf ../Parse/${ANTLR}; mv javax org ..)
	jar cfm ${EXE} Manifest.txt ${JAR}
	rm -rf tmp javax org
	rm -rf ${PDIR}/*.interp ${PDIR}/*.tokens ${PDIR}/*.java

all: antlr
	javac ${JFLAG} ${MAIN}.java ${PDIR}/${LANG}*.java ${TDIR}/*.java

antlr: ${PDIR}/${LANG}.g4
	(cd ${PDIR}; ${ARUN} ${LANG}.g4)

test: all test.vcg
	${GRUN} ${PDIR}.${LANG} ${START} test.vcg

test-gui:
	${GRUN} ${PDIR}.${LANG} ${START} -gui test.vcg

clean:
	rm -rf *.class *~ ${TDIR}/*.class ${TDIR}/*~ org javax tmp
	(cd ${PDIR}; rm -f ${LANG}*.java ${LANG}*.tokens *.interp *.class *~)

veryclean:
	rm -f *.class *~ ${TDIR}/*.class ${TDIR}/*~ ${EXE}
	(cd ${PDIR}; rm -f ${LANG}*.java ${LANG}*.tokens *.interp *.class *~)

