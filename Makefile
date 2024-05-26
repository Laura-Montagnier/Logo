CAMLC=$(BINDIR)ocamlc
CAMLDEP=$(BINDIR)ocamldep
CAMLLEX=$(BINDIR)ocamllex
CAMLYACC=$(BINDIR)ocamlyacc

#COMPFLAGS=-I `ocamlfind query graphics`
COMPFLAGS = -I /home/laura/.opam/default/lib/graphics/
#CAML_B_LFLAGS = `ocamlfind query -predicates byte -a-format graphics`
CAML_B_LFLAGS = /home/laura/.opam/default/lib/graphics/graphics.cma

SOURCES = ast.ml logosem.ml main.ml
GENERATED = lexer.ml parser.ml parser.mli
OBJS = $(GENERATED:.ml=.cmo) $(SOURCES:.ml=.cmo)
EXEC = my-wonderful-program.x

all: $(EXEC)

$(EXEC): $(OBJS)
	$(CAMLC) $(CAML_B_LFLAGS) $(COMPFLAGS) $(OBJS) -o $(EXEC)

.SUFFIXES:
.SUFFIXES: .ml .mli .cmo .cmi .cmx
.SUFFIXES: .mll .mly

.ml.cmo:
	$(CAMLC) $(COMPFLAGS) -c $<

.mli.cmi:
	$(CAMLC) $(COMPFLAGS) -c $<

.mll.ml:
	$(CAMLLEX) $<

.mly.ml:
	$(CAMLYACC) $<

.mly.mli:    # Rule to generate parser.mli from parser.mly
	$(CAMLYACC) $<

lexer.cmo: lexer.ml
	$(CAMLC) $(COMPFLAGS) -c $<

parser.cmo: parser.ml
	$(CAMLC) $(COMPFLAGS) -c $<

parser.cmi: parser.mli
	$(CAMLC) $(COMPFLAGS) -c $<

clean:
	rm -f *.cm[io] *.cmx *~ .*~ *.o *.x
	rm -f $(GENERATED) parser.mli
	rm -f $(EXEC)

# Dependencies
depend: $(SOURCES) $(GENERATED) $(MLIS)
	$(CAMLDEP) $(SOURCES) $(GENERATED) $(MLIS) > .depend

include .depend

