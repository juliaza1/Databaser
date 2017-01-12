create table pers (
	fnr integer primary key,
	etternavn varchar(50) not null,
	fornavn varchar(50) not null,
	adresse varchar(100) not null
);

create table ekteskap (
	dato date,
	fnr1 integer references pers(fnr),
	fnr2 integer references Pers(fnr),
	etternavn1 varchar(100),
	etternavn2 varchar(100),
	primary key (dato,fnr1),
	unique (dato, fnr2)
);

create table forrigenavn(
	dato date,
	fnr integer references pers(fnr),
	etternavn varchar(100),
	fornavn varchar(100),
	primary key (dato, fnr)
);

insert into ekteskap (dato, fnr1, fnr2, etternavn1, etternavn2)
values ('01-01-2010',1,2, 'Hansen', 'Hansen');

insert into ekteskap (dato, fnr1, fnr2, etternavn1, etternavn2)
values ('01-01-2010',3,4, 'Hansen', 'Andersen');

insert into ekteskap (dato, fnr1, fnr2, etternavn1, etternavn2)
values ('01-01-2010',5,6, 'Hansen Andersen', 'Andersen Hansen');

insert into ekteskap (dato, fnr1, fnr2, etternavn1, etternavn2)
values ('01-01-2010',7,8, 'Hansen-Andersen', 'Andersen-Hansen');

insert into ekteskap (dato, fnr1, fnr2, etternavn1, etternavn2)
values ('05-05-2010',1000,1010, 'Müllere', 'Müllere');




insert into forrigenavn (dato, fnr, etternavn, fornavn)
values ('01-01-2010', 1, 'Andersen', 'Julia'), ('01-01-2010', 2, 'Hansen', 'Kai');

insert into forrigenavn (dato, fnr, etternavn, fornavn)
values ('02-02-2010', 2, 'Andersen', 'Julia'), ('02-02-2010', 3, 'Hansen', 'Kai');

insert into forrigenavn (dato, fnr, etternavn, fornavn)
values ('03-03-2010', 4, 'Andersen', 'Julia'), ('03-03-2010', 5, 'Hansen', 'Kai');

insert into forrigenavn (dato, fnr, etternavn, fornavn)
values ('04-04-2010', 6, 'Andersen', 'Julia'), ('04-04-2010', 7, 'Hansen', 'Kai');

insert into forrigenavn (dato, fnr, etternavn, fornavn)
values ('05-05-2010', 1000, 'Bertrampfff', 'Aksel');

insert into forrigenavn (dato, fnr, etternavn, fornavn)
values ('05-05-2010', 1010, 'Müllereee', 'Kaja');

insert into pers (fnr, etternavn, fornavn, adresse)
values (1, 'Hansen', 'Julia', 'Aeins');

insert into pers (fnr, etternavn, fornavn, adresse)
values (2, 'Hansen', 'Kai', 'Aeins');

insert into pers (fnr, etternavn, fornavn, adresse)
values (3, 'Hansen', 'Kai', 'Azwei');

insert into pers (fnr, etternavn, fornavn, adresse)
values (4, 'Andersen', 'Melissa', 'Azwei');

insert into pers (fnr, etternavn, fornavn, adresse)
values (5, 'Hansen Andersen', 'Julia', 'Adrei');

insert into pers (fnr, etternavn, fornavn, adresse)
values (6, 'Andersen Hansen', 'Arne', 'Adrei');

insert into pers (fnr, etternavn, fornavn, adresse)
values (7, 'Hansen-Andersen', 'Arne', 'Avier');

insert into pers (fnr, etternavn, fornavn, adresse)
values (8, 'Andersen-Hansen', 'Arne', 'Avier');

insert into pers (fnr, etternavn, fornavn, adresse)
values (1000, 'Müllere', 'Aksel', 'Afem');

insert into pers (fnr, etternavn, fornavn, adresse)
values (1010, 'Bertrampfe', 'Kaja', 'Afem');


select p.etternavn, p.fnr
from forrigenavn f1, forrigenavn f2, ekteskap e, pers p 
where e.etternavn1 like ('%' || f1.etternavn)
and e.etternavn1 like (f2.etternavn || '%')
and e.etternavn1 <> e.etternavn2
and e.etternavn1 <> f1.etternavn
and f1.dato = e.dato
and f2.dato = e.dato
and e.fnr1 = p.fnr
UNION ALL
select p.etternavn, p.fnr
from forrigenavn f1, forrigenavn f2, ekteskap e, pers p 
where e.etternavn2 like ('%' || f2.etternavn)
and e.etternavn2 like (f1.etternavn || '%')
and e.etternavn1 <> e.etternavn2
and e.etternavn2 <> f2.etternavn
and f1.dato = e.dato
and f2.dato = e.dato
and e.fnr2 = p.fnr
;


