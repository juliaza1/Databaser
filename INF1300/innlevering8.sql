#1.
SELECT 
	title, 
	prodyear
FROM 
	film f,
	filmgenre fg
WHERE 
	title LIKE 'Rush Hour%'
	AND f.filmid = fg.filmid
	AND fg.genre = 'Action';

#2. 
SELECT
	f.title,
	f.prodyear,
	i.filmtype
FROM
	film f,
	filmitem i
WHERE
	f.filmid = i.filmid
	AND f.prodyear = 1893;

#3
SELECT 
	p.firstname || ' ' || p.lastname AS name
FROM
	person p,
	film f,
	filmparticipation fp
WHERE
	f.title = 'Baile Perfumado'
	AND fp.personid = p.personid
	AND fp.filmid = f.filmid
	AND fp.parttype = 'cast';

#4
SELECT
	f.title,
	f.prodyear
FROM
	film f,
	person p,
	filmparticipation fp
WHERE
	f.filmid = fp.filmid
	AND fp.parttype = 'director'
	AND fp.personid = p.personid
	AND p.firstname = 'Ingmar'
	AND p.lastname = 'Bergman'
ORDER BY 
	f.prodyear DESC;

#5
SELECT
	MIN(f.prodyear) første,
	MAX(f.prodyear) siste
FROM
	film f,
	person p,
	filmparticipation fp
WHERE
	f.filmid = fp.filmid
	AND fp.parttype = 'director'
	AND fp.personid = p.personid
	AND p.firstname = 'Ingmar'
	AND p.lastname = 'Bergman';

#6
SELECT
	firstprodyear,
	COUNT(*)
FROM
	series
WHERE
	firstprodyear = 2008
	OR firstprodyear = 2009
GROUP BY
	firstprodyear;

#7
SELECT
	f.title,
	f.prodyear
FROM
	film f,
	filmparticipation fp
WHERE
	f.filmid = fp.filmid
GROUP BY
	f.title,
	f.prodyear
HAVING
  	COUNT(DISTINCT fp.personid) > 300;

#8
SELECT
	p.firstname || ' ' || p.lastname AS name,
	COUNT(f.filmid) AS antallFilmer,
	MIN(f.prodyear) AS førsteFilm,
	MAX(f.prodyear) AS sisteFilm
FROM
	person p,
	film f,
	filmparticipation fp
WHERE
	f.filmid = fp.filmid
	AND fp.parttype = 'director'
	AND fp.personid = p.personid
GROUP BY
	name,
	p.personid
HAVING
	MAX(f.prodyear) - MIN(f.prodyear) > 49
ORDER BY
	MAX(f.prodyear) - MIN(f.prodyear) DESC;




