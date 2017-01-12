#3A

SELECT p.fnavn, p.adresse, p.etternavn
FROM person p, forrigenavn f, ekteskap e
WHERE p.fnr = f.fnr
AND f.dato = e.dato
AND e.fnr1 = p.fnr 
AND f.etternavn <> p.etternavn
AND dato between(2000,2010)
AND e.etternavn1 <> e.etternavn2
UNION ALL
SELECT p.fnavn, p.adresse, p.etternavn
FROM person p, forrigenavn f, ekteskap e
WHERE p.fnr = f.fnr
AND f.dato = e.dato
AND e.fnr2 = p.fnr 
AND f.etternavn <> p.etternavn
AND dato between(2000,2010)
AND e.etternavn1 <> e.etternavn2


#3B

SELECT p.etternavn, p.fnr
FROM forrigenavn f1, forrigenavn f2, ekteskap e, pers p 
WHERE e.etternavn1 LIKE ('%' || f1.etternavn)
AND e.etternavn1 LIKE (f2.etternavn || '%')
AND e.etternavn1 <> e.etternavn2
AND e.etternavn1 <> f1.etternavn
AND f1.dato = e.dato
AND f2.dato = e.dato
AND e.fnr1 = p.fnr
UNION ALL
SELECT p.etternavn, p.fnr
FROM forrigenavn f1, forrigenavn f2, ekteskap e, pers p 
WHERE e.etternavn2 LIKE ('%' || f2.etternavn)
AND e.etternavn2 LIKE (f1.etternavn || '%')
AND e.etternavn1 <> e.etternavn2
AND e.etternavn2 <> f2.etternavn
AND f1.dato = e.dato
AND f2.dato = e.dato
AND e.fnr2 = p.fnr;


#4A

WITH Recursive foo(person,selskap,dybde,liste,sykel) as (
SELECT s.person, s.selskap, 0, ARRAY[s.person], false
FROM selskapsinfo s WHERE s.person = 'Anne Hol'

UNION

SELECT s2.person, s2.selskap, f.dybde + 1, liste || s2.person, s2.person = ANY(f.liste)
FROM selskapsinfo s1, selskapsinfo s2, foo f
WHERE s1.selskap = f.selskap
AND NOT f.sykel
AND s1.person = s2.person
AND s2.selskap <> s1.selskap
AND s1.selskap = f.selskap
)
SELECT * FROM foo f WHERE f.person = 'Einar Aas' ORDER BY f.dybde LIMIT 1;


#4B

WITH RECURSIVE sykel (s1, s2, personer, selskaper) as
#første og siste selskap
# person
# selskapene i stien
SELECT s1.selskap, s2.selskap, array[s2.person], array[s1.selskap, s2.selskap]
FROM Selskapsinfo s1, Selskapsinfo s2
WHERE s1.rolle = 'daglig leder'
AND s1.selskap <> s2.selskap
AND s2.rolle = any(array['styreleder', 'nestleder', 'styremedlem'])
AND s1.person = s2.person
UNION ALL
SELECT c.s1, s2.selskap, c.personer || s2.person, c.selskaper || s2.selskap
FROM sykel c, Selskapsinfo s1, Selskapsinfo s2
WHERE c.s1 <> c.s2 #fortsetter bare hvis stien hittil ikke er en sykel
AND c.s2 = s1.selskap 
AND s2.person <> all(c.personer) #Avskjærer sykler i sykler
AND s2.rolle = any(array['styreleder', 'nestleder', 'styremedlem'])
AND s1.rolle = 'daglig leder'
AND s1.selskap <> s2.selskap
AND s1.person = s2.person
AND cardinality(c.personer) <= 5
)

SELECT personer, selskaper[1:cardinality(selskaper) - 1] 
#skriver ut alle elementer i selskaper bortsett fra den siste. siden den er den første igjen
FROM sykel
WHERE s1 = s2 #Da er det en sykel
AND cardinality(personer) >= 3
AND cardinality(personer) <= 5
AND personer[1] <= all(personer) #skriver kun ut personen som har første bokstaven i alfabetet (ingen duplikater)
#resultat: 8 rows


# 5A

SELECT s.maintitle, s.firstprodyear, COUNT(e.seriesid) AS antall
FROM series s LEFT OUTER JOIN episode e ON s.seriesid = e.seriesid, 
	(SELECT MAX(firstprodyear) AS yr FROM series) fpy
WHERE s.firstprodyear = fpy.yr
GROUP BY s.maintitle, s.firstprodyear;


#5B

SELECT DISTINCT f.parttype, round(((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM filmparticipation)),1) AS percentage 
FROM filmparticipation f, Person P
WHERE f.personid = P.personid
GROUP BY f.parttype
ORDER BY percentage desc;


#5C2

SELECT p.firstname, p.lastname
FROM person p,
     (SELECT f.personid
      FROM filmparticipation f, filmitem i
      WHERE i.filmtype = 'C' AND f.parttype = 'cast' AND
            f.filmid = i.filmid
      GROUP BY f.personid
      HAVING count(distinct f.filmid) > 50) as p50
WHERE p.personid = p50.personid AND
      p.gender = 'F' AND
      p.lastname <= all (SELECT min(q.lastname)
                         FROM filmparticipation h,
                              person q,
                              (SELECT g.filmid
                               FROM filmparticipation g, filmitem j
                               WHERE g.personid = p50.personid
                                     AND g.filmid = j.filmid
                                     AND g.parttype = 'cast'
                                     AND j.filmtype = 'C') as f50
                         WHERE h.filmid = f50.filmid
                               AND h.parttype = 'cast'
                               AND h.personid = q.personid
                               AND q.gender = 'F'
                         GROUP BY f50.filmid);
​



