# Makefile for the CSC 7101 Verification Condition Generator

MAIN = VCG
LANG = IMP
PDIR = Parse
TDIR = Tree
START= program
TEST_DIR = TestData
EXE  = VCG.jar
JAR  = VCG.class Parse/*.class Parse/*.tokens Tree/*.class javax org

# Change CPSEP to ; on Windows
CPSEP= :
ANTLR= antlr-4.7.1-complete.jar

ARUN = java -jar ${ANTLR}
GRUN = java -cp ".${CPSEP}${PDIR}/${ANTLR}" org.antlr.v4.gui.TestRig
JFLAG= -g -cp ${PDIR}/${ANTLR}

all: antlr
	javac ${JFLAG} ${MAIN}.java ${PDIR}/${LANG}*.java ${TDIR}/*.java

antlr: ${PDIR}/${LANG}.g4
	(cd ${PDIR}; ${ARUN} ${LANG}.g4)

test-all: all
	${GRUN} ${PDIR}.${LANG} ${START} \
	 ${TEST_DIR}/test_assert.vcg \
	 ${TEST_DIR}/test_assign.vcg \
	 ${TEST_DIR}/test_bool.vcg \
	 ${TEST_DIR}/test_call.vcg \
	 ${TEST_DIR}/test_compexp.vcg \
	 ${TEST_DIR}/test_if.vcg \
	 ${TEST_DIR}/test_imp_eqv.vcg \
	 ${TEST_DIR}/test_not.vcg \
	 ${TEST_DIR}/test_quantum.vcg \
	 ${TEST_DIR}/test_skip.vcg \
	 ${TEST_DIR}/test_uminus.vcg \
	 ${TEST_DIR}/test_while.vcg

test: all test.vcg
	${GRUN} ${PDIR}.${LANG} ${START} ${ARGS}

test-gui: all test.vcg
	${GRUN} ${PDIR}.${LANG} ${START} -gui test.vcg

jar: all
	mkdir -p tmp
	(cd tmp; jar xf ../Parse/${ANTLR}; mv javax org ..)
	jar cfm ${EXE} Manifest.txt ${JAR}
	rm -rf tmp javax org

clean:
	rm -f *.class *~ ${TDIR}/*.class ${TDIR}/*~
	(cd ${PDIR}; rm -f ${LANG}*.java ${LANG}*.tokens *.interp *.class *~)

veryclean:
	rm -f *.class *~ ${TDIR}/*.class ${TDIR}/*~ ${EXE}
	rm -r org/ out/ tmp/ javax/
	(cd ${PDIR}; rm -f ${LANG}*.java ${LANG}*.tokens *.interp *.class *~)

