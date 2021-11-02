CC              =       /bin/gcc
CC2             =       /bin/gcc
CFLAGS          =       -g $(CFLAGS) -I$(PGHOME)/include -Wall
LIBDIR          =       -L$(PGHOME)/lib
INCLUDE         =       -I$(PGHOME)/include -I./

LDFLAGS= $(LDFLAGS) -L$(PGHOME)/lib -Wl,-rpath,$(PGHOME)/lib
LDLIBS= $(LDLIBS) -lecpg
 
PROGRAMS = anonymous
 
.PHONY: all clean
 
%.c: %.pgc
	ecpg $<
 
all: $(PROGRAMS)
anonymous.c:	anonymous.pgc
	ecpg $<
anonymous.o:	anonymous.c
	$(CC) -c $(CFLAG) $(INCLUDE) $<
anonymous:	anonymous.o
	$(CC) $(LIBDIR) -o anonymous $< -lecpg
clean:
	rm -f $(PROGRAMS) $(PROGRAMS:%=%.c) $(PROGRAMS:%=%.o) nohup.out

create_random_table:
	psql -c 'drop table pmdm.person_random cascade' -d pm2p
	psql -c 'create table pmdm.person_random as select distinct person_id,first_name,family_name,gender from pmdm.person_data' -d pm2p
	psql -c 'CREATE INDEX num1 ON pmdm.person_random(person_id)' -d pm2p
create_table_anonymous:
	psql -c 'drop table pmdm.person_anonym cascade' -d pm2p
	psql -c 'create table pmdm.person_anonym as select * from pmdm.person_data' -d pm2p
	psql -c 'CREATE INDEX num2 ON pmdm.person_anonym(person_id)'  -d pm2p
	psql -c 'drop table pmdm.person_index_anonym cascade' -d pm2p
	psql -c 'create table pmdm.person_index_anonym as select * from pmdm.person_index' -d pm2p
	psql -c 'CREATE INDEX num3 ON pmdm.person_index_anonym(person_id)'  -d pm2p
