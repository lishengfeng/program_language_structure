import org.antlr.v4.runtime.*;

import Parse.*;
import Tree.*;

import java.io.BufferedReader;
import java.io.FileReader;

public class VCG {
    public static void main(String[] args) throws Exception {
        if (args.length < 1) {
            System.err.println("Usage: java VCG test.vcg");
            System.exit(1);
        }

        for (String s : args) {
            System.out.println("--------------------------------------------");
            try (BufferedReader br = new BufferedReader(new FileReader(s))) {
                String line;
                while ((line = br.readLine()) != null) {
                    System.out.println(line);
                }
            }
            System.out.println();
            CharStream input = CharStreams.fromFileName(s);
            IMPLexer lexer = new IMPLexer(input);
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            IMPParser parser = new IMPParser(tokens);
            parser.program();
        }
    }
}
