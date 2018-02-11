To test the _IMP.g4_. You can either use jar or use make command

jar: (show all test)


    java -jar VCG.jar \
	 TestData/test_assert.vcg \
	 TestData/test_assign.vcg \
	 TestData/test_bool.vcg \
	 TestData/test_call.vcg \
	 TestData/test_compexp.vcg \
	 TestData/test_if.vcg \
	 TestData/test_imp_eqv.vcg \
	 TestData/test_not.vcg \
	 TestData/test_quantum.vcg \
	 TestData/test_skip.vcg \
	 TestData/test_uminus.vcg \
	 TestData/test_while.vcg

makefile:
you will need to specify which vcg test file. For example:

    make ARGS="TestData/test_assert.vcg" test
    
will use file TestData/test_assert.vcg as input (if you are using windows, the slash should be "\")
