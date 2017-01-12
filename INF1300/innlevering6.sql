OPPGAVE 1
create table Kunde 
	(kundenummer int not null primary key, 
		kundenavn varchar(100) not null, 
		kundeadresse varchar(200) not null), 
	kundefakturaadresse varchar(200) not null);

create Table Offentlig_Etat 
	(kundenummer int primary key references Kunde (kundenummer), 
		departement varchar (120) not null);

create table Firma 
	(kundenummer int primary key references Kunde (kundenummer), 
		org_nummer int not null);

create table Telefonnummer 
	(nummer int not null primary key, 
		kundenummer int references Kunde (kundenummer)); 

create table Prosjekt 
	(prosjektnummer int not null primary key, 
		prosjektleder int references Ansatt(ansattnr) not null, 
		prosjektnavn varchar(120) not null, 
		kundenummer int references Kunde (kundenummer));

create Table Ansatt 
	(ansattnr int not null primary key, 
		gruppenavn varchar(120) references Gruppe(gruppenavn)); 

create Table AnsattDeltarIProsjekt 
	(ansattnr int not null references Ansatt(ansattnr), 
		prosjektnr int references Prosjekt(prosjektnummer), 
		PRIMARY KEY (ansattnr,prosjektnr));

create Table Gruppe 
	(gruppenavn varchar(120) not null primary key, 
		timelønn int not null);



OPPGAVE 2
(1)
SELECT 	 	distinct kundenummer, kundenavn, kundeadresse
FROM 	 	Kunde
ORDER BY  	kundenummer ASC;

(2)
SELECT	 	distinct kundenummer, nummer
FROM 	 	Telefonnummer
ORDER BY 	kundenummer DESC;

(3)
SELECT	 	distinct ansattnr
FROM 	 	Prosjekt P, Ansatt A
WHERE 	 	P.prosjektleder = A.ansattnr;

(4)
SELECT	 	distinct ansattnr
FROM	 	AnsattDeltarIProsjekt A, Prosjekt P
WHERE	 	P.prosjektnavn = 'Ruter app' and P.prosjektnummer = A.prosjektnr;

(5)
SELECT 	 	distinct ansattnr, timelønn
FROM	  	Ansatt A, Gruppe G
WHERE	  	A.gruppenavn = G.gruppenavn;

(6)
SELECT 	 	distinct org_nummer, kundenavn
FROM	  	Firma F, Offentlig_Etat O, Kunde K
WHERE	  	F.kundenummer = O.kundenummer ;
