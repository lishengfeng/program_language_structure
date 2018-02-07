import org.antlr.v4.runtime.*;

import Parse.*;
import Tree.*;

public class VCG {
    public static void main(String[] args) throws Exception {
	if (args.length != 1) {
	    System.err.println("Usage: java VCG test.vcg");
	    System.exit(1);
	}

        ANTLRInputStream input = new ANTLRFileStream(args[0]);
        IMPLexer lexer = new IMPLexer(input);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        IMPParser parser = new IMPParser(tokens);

	parser.program();
    }
}
