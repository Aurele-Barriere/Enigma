# Options du compilateur
# ======================
#
# On active -g pour le debug, cela permet notamment d'obtenir
# des backtraces en passant OCAMLRUNPARAM=b dans l'environnement.
#
# Pour une exécution rapide du code finalisé, on pourra enlever -g et
# utiliser des options comme -noassert -unsafe -inline 4.

OCAMLC=ocamlopt -w A-3 -g
# OCAMLC=ocamlopt -w A-3 -noassert -unsafe -inline 4

# Sources
# =======
# On prend en compte et compile tous les *ml et *mli présents.

SOURCES=$(shell ocamldep -sort $(wildcard *.ml))
MODULES=$(SOURCES:.ml=.cmx)

# Cibles
# ======
# On pourra activer la cible enigma dès que le module Symbol sera complété.
# On pourra, si besoin ajouter des alias à la liste définie ci-dessous,
# qui correspond aux exécutables requis pour le projet.

all: $(MODULES) 
doc: html/index.html

ALIASES = cycles bombe brute tests

# Recettes
# ========
# Pour compiler l'exécutable enigma, ses aliases, et diverses recettes
# génériques. En principe, il n'y a aucune raison de modifier tout cela.

enigma: $(MODULES)
	$(OCAMLC) unix.cmxa $(MODULES) -o enigma
	for i in $(ALIASES) ; do test -f $$i || ln -s enigma $$i ; done

%.cmx: %.ml Makefile
	$(OCAMLC) -c $<

%.cmi: %.mli Makefile
	$(OCAMLC) -c $<

-include .depend

.depend: $(SOURCES) $(wildcard *.mli)
	ocamldep *.ml *.mli > .depend

clean:
	rm -f *.cm* *.o
	rm -f enigma $(ALIASES)

html/index.html: $(wildcard *.ml) $(wildcard *.mli) Makefile
	mkdir -p html
	ocamldoc -stars -html -d html *.ml *.mli
