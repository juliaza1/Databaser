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

#5C



# episode: episdeid, seriesid, subtitle
# series: seriesid, maintitle, firstprodyear
# filmparticipation: partid, personid, filmid, parttype

#4a

#RIKTIG LØSNING FOR 4a
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


#Oppgave 4b)
#Selskapsinfo(selskap, rolle, person)
WITH RECURSIVE sykel (s1, s2, personer, selskaper) as
#første og siste selskap
# person
# selskapene i stien
SELECT s1.selskap, s2.selskap, array[s2.person], array[s1.selskap, s2.selskap]
FROM Selskapsinfo s1, Selskapsinfo s2
WHERE s1.rolle = 'daglig leder'
and s1.selskap <> s2.selskap
and s2.rolle = any(array['styreleder', 'nestleder', 'styremedlem'])
and s1.person = s2.person

UNION ALL

SELECT c.s1, s2.selskap, c.personer || s2.person, c.selskaper || s2.selskap
FROM sykel c, Selskapsinfo s1, Selskapsinfo s2
WHERE c.s1 <> c.s2 #fortsetter bare hvis stien hittil ikke er en sykel
and c.s2 = s1.selskap 
and s2.person <> all(c.personer) #Avskjærer sykler i sykler
and s2.rolle = any(array['styreleder', 'nestleder', 'styremedlem'])
and s1.rolle = 'daglig leder'
and s1.selskap <> s2.selskap
and s1.person = s2.person
and cardinality(c.personer) <= 5
)


SELECT personer, selskaper[1:cardinality(selskaper) - 1] #skriver ut alle elementer i selskaper bortsett fra den siste. siden den er den første igjen
FROM sykel
WHERE s1 = s2 #Da er det en sykel
and cardinality(personer) >= 3
and cardinality(personer) <= 5
and personer[1] <= all(personer) #skriver kun ut personen som har første bokstaven i alfabetet (ingen duplikater)
#resultat: 8 rows


--5C2
select p.firstname, p.lastname
from person p,
     (select f.personid
      from filmparticipation f, filmitem i
      where i.filmtype = 'C' and f.parttype = 'cast' and
            f.filmid = i.filmid
      group by f.personid
      having count(distinct f.filmid) > 50) as p50
where p.personid = p50.personid and
      p.gender = 'F' and
      p.lastname <= all (select min(q.lastname)
                         from filmparticipation h,
                              person q,
                              (select g.filmid
                               from filmparticipation g, filmitem j
                               where g.personid = p50.personid
                                     and g.filmid = j.filmid
                                     and g.parttype = 'cast'
                                     and j.filmtype = 'C') as f50
                         where h.filmid = f50.filmid
                               and h.parttype = 'cast'
                               and h.personid = q.personid
                               and q.gender = 'F'
                         group by f50.filmid);
​






####




#####
SELECT COUNT(*) from person p
WHERE (SELECT COUNT(*)
  FROM filmparticipation fp
  WHERE fp.personid = p.personid
  AND (SELECT COUNT(*) FROM filmparticipation cp
    WHERE (SELECT cper.lastname
        FROM person cper
        WHERE cp.filmid = fp.filmid AND cper.personid = cp.personid
        AND cper.gender = 'F'
        ORDER BY cper.lastname
        LIMIT 1) = p.lastname
    AND cp.parttype= 'cast') > 0
  AND fp.parttype = 'cast') > 50
  AND p.gender = 'F';


  ####    
SELECT p.firstname, p.lastname from person p
WHERE p.gender = 'F'
  AND (SELECT COUNT(*)
  FROM filmparticipation fp
  INNER JOIN filmparticipation cp ON cp.filmid = fp.filmid
    AND cp.parttype= 'cast'
    AND (SELECT cper.lastname
      FROM person cper
      WHERE cper.personid = cp.personid
      AND cper.gender = 'F'
      ORDER BY cper.lastname
      LIMIT 1) = p.lastname
  WHERE fp.personid = p.personid
  AND fp.parttype = 'cast') > 50
  ORDER BY p.firstname, p.lastname;


####
SELECT COUNT(*)
FROM filmparticipation pa, person p
WHERE p.personid=pa.personid AND p.gender = 'F' AND pa.parttype = 'cast'
AND (
  SELECT COUNT(*) FROM filmparticipation pb 
  WHERE pb.personid = p.personid
  ) > 50
AND p.personid = (
  SELECT p2.personid
  FROM person p2
  JOIN filmparticipation pc ON pc.filmid = pa.filmid AND pc.parttype = 'cast'
  ORDER BY p2.lastname
  LIMIT 1
  );


####
SELECT COUNT(DISTINCT p.personid)
FROM person p
JOIN filmparticipation pa
ON p.personid = pa.personid
WHERE p.personid=pa.personid AND p.gender = 'F' AND pa.parttype = 'cast'
AND (SELECT COUNT(*)
  FROM filmparticipation pb 
  WHERE pb.personid = p.personid
  AND pb.parttype = 'cast') > 50
AND p.personid = (
  SELECT p2.personid
  FROM person p2
  JOIN filmparticipation pc ON pc.filmid = pa.filmid AND pc.parttype = 'cast'
  AND p2.gender = 'F'
  ORDER BY p2.lastname
  LIMIT 1);



##########



SELECT DISTINCT COUNT(DISTINCT per.personid) FROM person per
INNER JOIN filmparticipation partA ON partA.personid = per.personid
INNER JOIN filmitem item ON item.filmid = partA.filmid
WHERE per.gender = 'F'
AND partA.parttype = 'cast'
AND item.filmtype = 'C'
AND (SELECT COUNT(*) FROM filmparticipation partB
  WHERE partB.personid = per.personid AND partB.parttype = 'cast') > 50
AND per.lastname = (SELECT perB.lastname
  FROM person perB
  JOIN filmparticipation partC
  ON partC.personid = perB.personid
  AND partC.filmid = partA.filmid
  WHERE perB.gender = 'F'
  AND partC.parttype = 'cast'
  ORDER BY perB.lastname
  FETCH FIRST 1 ROWS ONLY);




#




SELECT DISTINCT COUNT(DISTINCT per.personid) FROM person per
JOIN filmparticipation partA ON partA.personid = per.personid
JOIN filmitem item ON item.filmid = partA.filmid
WHERE per.gender = 'F'
AND partA.parttype = 'cast'
AND item.filmtype = 'C'
AND per.lastname = (SELECT perB.lastname
FROM filmparticipation partB
JOIN person perB ON perB.personid = partB.personid
WHERE partB.parttype = 'cast'
AND partB.filmid = partA.filmid
AND perB.gender = 'F'
ORDER BY perB.lastname ASC
LIMIT 1)
AND (SELECT COUNT(distinct partA.partid) FROM filmparticipation partC
  JOIN filmitem itemC ON itemC.filmid = partC.filmid AND itemC.filmtype = 'C'
  WHERE partC.personid = per.personid AND partC.parttype = 'cast') > 50;






SELECT DISTINCT COUNT(DISTINCT per.personid) FROM person per
JOIN filmparticipation partA ON partA.personid = per.personid
JOIN filmitem item ON item.filmid = partA.filmid
WHERE per.gender = 'F'
AND partA.parttype = 'cast'
AND item.filmtype = 'C'
AND per.lastname = (SELECT perB.lastname
FROM filmparticipation partB
JOIN person perB ON perB.personid = partB.personid
WHERE partB.parttype = 'cast'
AND partB.filmid = partA.filmid
AND perB.gender = 'F'
ORDER BY perB.lastname ASC
LIMIT 1)
HAVING 50 < COUNT(distinct partA.partid);






-- ____________________




SELECT p.lastname, p.firstname
from person p, filmparticipation x, filmitem f
where x.personid = p.personid 
and p.gender = 'F' 
and f.filmtype = 'C'
and x.parttype = 'cast' 
and f.filmid = x.filmid
group by p.lastname, p.firstname
having count (*) > 50

intersect 

-- henter alle kvinnelige skuespillere
-- sorterer på etternavn (alfabetisk)
-- fjerner alle bortsett fra den første
SELECT p.lastname, p.firstname
FROM person p, filmparticipation x, filmitem f
where x.personid = p.personid 
and p.gender = 'F' 
and f.filmtype = 'C'
and x.parttype = 'cast' 
and f.filmid = x.filmid 
order by p.lastname, p.firstname
limit 1;