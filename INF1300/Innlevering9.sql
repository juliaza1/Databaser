CREATE TYPE GAR as ENUM ('Lite', 'Middels', 'God');

CREATE TYPE FYL as ENUM ('Lett', 'Middels', 'God', 'Fyldig');

CREATE TYPE FRI as ENUM ('Svak', 'Middels', 'God', 'Frisk til svaert frisk');

CREATE TYPE SOE as ENUM ('Toerr', 'Halvtoerr', 'Halvsoet', 'Soet');

CREATE TABLE Vin (
	Varenr integer PRIMARY KEY,
	Navn text NOT NULL,
	Aarstall integer NOT NULL,
	Land_Distrikt text NOT NULL,
	PasserTil text,
	PaaLager boolean,
	Karakteristisk text,
	Farge text,
	Lukt text,
	Smak text,
	Raastoffer text,
	Kork text,
	Emballasje text
);

CREATE TABLE Pris (
	Varenr integer REFERENCES Vin,
	NOK numeric NOT NULL,
	CHECK (NOK > 0),
	PRIMARY KEY (Varenr)
);

CREATE TABLE Volum (
	Varenr integer REFERENCES Vin,
	CL float NOT NULL,
	PRIMARY KEY (Varenr)
);

CREATE TABLE Produsent (
	ProdID integer PRIMARY KEY,
	Adresse text NOT NULL,
	Produsentnavn text NOT NULL,
	UNIQUE (Adresse, Produsentnavn)
);

ALTER TABLE Vin 
	ADD COLUMN Produsent integer REFERENCES Produsent
;

CREATE TABLE Telefon (
	Telefonnr integer PRIMARY KEY,
	ProdID integer REFERENCES Produsent UNIQUE
);

CREATE TABLE Kunde (
	KundeID integer PRIMARY KEY
);

ALTER TABLE VIN 
	ADD COLUMN KundeID integer REFERENCES Kunde
;

CREATE TABLE Roedvin (
	Varenr integer REFERENCES Vin PRIMARY Key,
	Garvestoffer GAR,
	Fylde FYL
);

CREATE TABLE Rosee (
	Varenr integer REFERENCES Vin,
	Fylde FYL,
	Friskhet FRI,
	PRIMARY KEY (Varenr)
);

CREATE TABLE Hvitvin (
	Varenr integer REFERENCES Vin,
	Friskhet FRI,
	Soedme SOE,
	PRIMARY KEY (Varenr)
);

CREATE TABLE Musserende (
	Varenr integer REFERENCES Vin,
	Friskhet FRI,
	Soedme SOE,
	PRIMARY KEY (Varenr)
);

CREATE TABLE Fruktvin (
	Varenr integer REFERENCES Vin,
	PRIMARY KEY (Varenr)
);

CREATE TABLE Alkoholfritt (
	Varenr integer REFERENCES Vin,
	PRIMARY KEY (Varenr)
);

CREATE TABLE Liker (
	KundeID integer REFERENCES Kunde,
	Varenr integer REFERENCES Vin,
	PRIMARY KEY (KundeID, Varenr)
);



INSERT INTO Produsent (ProdID, Adresse, Produsentnavn)
VALUES (123, 'Abc gate', 'Moselland Winzergenossenschaft'),
(234, 'Cde vei', 'Robert Prizelius'),
(345, 'Efgplass', 'Osborne');

INSERT INTO Vin (Varenr, Navn, Aarstall, Land_Distrikt, PasserTil, PaaLager, Karakteristisk, Farge, Lukt, Smak, Raastoffer, Kork, Emballasje, Produsent) 
VALUES 
(687, 'Moselland Riesling Kabinett', 2013, 'Tyskland, Mosel', 'Fisk, Skalldyr, Ost', 'Y', 'Ung og ren', 'Lys groenn', 'Sitrus', 'Hint av Blomst og groent eple', 'Riesling 100%', 'Naturkork', 'Engangsflaske av glass', 123),
(579, 'Elise Liebfraumilch', 2013, 'Frankrike, Bretagne', 'Fisk, Skalldyr, Aperitif', 'Y', 'Drikkeklar', 'Lys gul', 'Sitrus og gule epler', 'fruktig med fin syrlighet', 'Mueller-Thurgau 50%, Silvaner 50%', 'Plastkork', 'Engangsflaske av glass', 234),
(941, 'Montecillo Selección Especial Gran Reserva', 1987, 'Spania, Rioja', 'Storfe, Lam og Sau, Storvilt', 'N', 'Drikkeklar, moden', 'Moerk kirsebaerroed', 'Roede baer', 'Kraftig, rik, elegant, bjoernebaer, lang', 'Tempranillo 100%','Naturkork', 'Engangsflaske av glass', 345),
(282, 'Dona Maria Rosé', 2014, 'Portugal, Alentejo', 'Ost, Fisk, Skalldyr', 'Y', 'Drikkeklar og frisk', 'Lys lakserosa', 'Frisk tropisk frukt', 'Frisk og fruktig med hint av jordbær', 'Aragónez 60%, Touriga Nacional 40%', 'Naturkork', 'Engangsflaske av glass', 234), 
(555, 'Liersider', 2010, 'Norge', 'Fisk, Lyst Kjoett, Svinekjoett', 'Y', 'Saftig', 'Middels dyp gyllen', 'Fint preg av eple', 'Saftig og frisk', '100% Aroma epler', 'Plastkork', 'Kartong', 123),
(180, 'Light Live Cabernet Sauvignon', 2014, 'Tyskland', 'Fisk, Svinekjoett, Groennsaker', 'N', 'Tradisjonell', 'Moerk roed', 'Ung, ren og litt undermoden stil', 'Dropsaktig arome', 'Cabernet Sauvignon 100%', 'Plastkork', 'Engangsflaske av glass', 123),
(940, 'Encholee di Gigolo', 2006, 'Spania, Rioja', 'Storfe, Lam og Sau, Storvilt', 'N', 'Drikkeklar, moden', 'Moerk kirsebaerroed', 'Roede baer', 'Kraftig, rik, elegant, bjoernebaer, lang', 'Tempranillo 100%','Naturkork', 'Engangsflaske av glass', 123),
(294, 'Gianni Gagliardo Villa M Cuvee Dolce', 2012, 'Italia, Piemonte', 'Aperitif, Dessert, Ost', 'N', 'Fin balanse', ' Klar straagul', 'Frisk, ren med god fruktighet', 'Frisk, konsentrert', 'Moscato 100%', 'Plastkork', 'Engangsflaske av glass', 123);

INSERT INTO Kunde (KundeID)
VALUES (1), (2), (3), (4);

INSERT INTO Telefon (Telefonnr, ProdID)
VALUES (12345678, 123), (23456789, 234), (34567890, 345);

INSERT INTO Hvitvin (Varenr, Friskhet, Soedme)
VALUES (687, 'Middels', 'Halvsoet'), (579, 'God', 'Toerr');

INSERT INTO Roedvin (Varenr, Garvestoffer, Fylde)
VALUES (941, 'Middels', 'Fyldig'), (940, 'Middels', 'Fyldig');

INSERT INTO Rosee (Varenr, Fylde, Friskhet)
VALUES (282, 'Lett', 'Frisk til svaert frisk');

INSERT INTO Liker (KundeID, Varenr)
VALUES (1, 687), (1, 941), (4, 687), (3, 579);

INSERT INTO Pris (Varenr, NOK)
VALUES (687, 145.50), (941, 1990), (579, 300), (282, 189.60), (940, 600);

INSERT INTO Volum (Varenr, CL)
VALUES (687, 75), (941, 300), (579, 75), (282, 75), (294, 75), (555, 37.5), (180, 75), (940, 200);

INSERT INTO Alkoholfritt (Varenr)
VALUES (180);

INSERT INTO Fruktvin (Varenr)
VALUES (555);

INSERT INTO Musserende (Varenr, Friskhet, Soedme)
VALUES (294, 'God', 'Halvsoet');



UPDATE Vin
SET Navn = 'Guy Saget Sancerre'
WHERE Varenr = 282;

UPDATE Vin
SET Navn = 'Laroche Chablis'
WHERE Varenr = 579;

UPDATE Produsent
SET Produsentnavn = 'Michel Laroche'
WHERE ProdID = 234;



-- NYE SELECTSETNINGER:

-- 1 Hvilke viner ble produsert i 2013, er fra Tyskland og passer til fisk?
-- 2 Hvilke rødviner er eldre enn 5 år, ble laget i Spania og koster mer enn 500 kr?
-- 3 Passer en Guy Saget Sancerre fra 2014 til skalldyr? 
-- (Output as boolean 0 = false, 1 = true)
-- 4 Er vinen med varenummer 555 på lager? 
-- (Output as boolean 0 = false, 1 = true)
-- 5 Hvilke viner er halvsøte, har naturkork og har volum 75 cl?
-- 6 Hvilke viner passer til dessert, er fra Italia og har plastkork?
-- 7 Er en Laroche Chablis fra 2013 en hvitvin som kommer i glassflasker? 
-- (Output as boolean 0 = false, 1 = true)
-- 8 Hvilke viner er lys groenn, lukter sitrus og ble produsert av Moselland Winzergenossenschaft?
-- 9 Hvor mange viner blir produsert av Michel Laroche?
-- 10 Er vinen med varenummer 294 en hvitvin fra Tyskland? (
-- Output as boolean 0 = false, 1 = true)

-- 1
SELECT Varenr, Navn
FROM Vin 
WHERE Aarstall = 2013 AND Land_Distrikt LIKE 'Tyskland%' AND PasserTil LIKE '%Fisk%';

-- 2
SELECT Vin.Varenr, Navn, Pris.NOK AS Pris
FROM Vin NATURAL JOIN Roedvin, Pris
WHERE Vin.Aarstall < 2010 AND Vin.Land_Distrikt LIKE 'Spania%' 
AND Vin.varenr = Pris.varenr 
GROUP BY Vin.Varenr, Pris
HAVING Pris.NOK > 500;

-- 3 -- true
SELECT CASE WHEN EXISTS (
SELECT *
FROM Vin 
WHERE PasserTil LIKE '%Skalldyr%' AND Navn LIKE 'Guy Saget Sancerre' AND Aarstall = 2014
)
THEN CAST(1 AS BIT)
ELSE CAST(0 AS BIT) END;

-- 4 - true
SELECT CASE WHEN EXISTS (
SELECT *
FROM Vin
WHERE Varenr = 555 AND PaaLager = 'Y')
THEN CAST(1 AS BIT)
ELSE CAST(0 AS BIT) END;

-- 5
SELECT DISTINCT Vin.Varenr, Vin.Navn
FROM Vin, Hvitvin FULL JOIN Musserende ON Hvitvin.varenr = Musserende.varenr, Volum
WHERE Vin.Kork LIKE 'Naturkork' AND Volum.CL = 75 AND Volum.varenr = Vin.varenr AND Vin.varenr = Hvitvin.varenr AND Hvitvin.Soedme = 'Halvsoet'
OR Musserende.Soedme = 'Halvsoet' AND Vin.varenr = Musserende.varenr 
ORDER BY Varenr ASC;

-- 6
SELECT Varenr, Navn
FROM Vin
WHERE Kork LIKE 'Plastkork' AND Land_Distrikt LIKE 'Italia%' AND PasserTil LIKE '%Dessert%';

-- 7 -- true
SELECT CASE WHEN EXISTS (
SELECT *
FROM Vin 
NATURAL JOIN Hvitvin
WHERE Navn LIKE 'Laroche Chablis' AND Aarstall = 2013 AND Emballasje Like '%glass' AND Hvitvin.varenr = Vin.varenr)
THEN CAST(1 AS BIT)
ELSE CAST(0 AS BIT) END;

-- 8
SELECT DISTINCT Varenr, Navn
FROM Vin NATURAL JOIN Produsent
WHERE Vin.Farge LIKE 'Lys groenn' AND Vin.Lukt LIKE 'Sitrus' AND Produsent.Produsentnavn LIKE 'Moselland Winzergenossenschaft';

-- 9
SELECT COUNT (DISTINCT Produsentnavn LIKE 'Michel Laroche')
FROM Vin NATURAL JOIN Produsent;

-- 10 -- false
SELECT CASE WHEN EXISTS (
SELECT Varenr, Navn
FROM Vin NATURAL JOIN Hvitvin
WHERE varenr = 294 AND Land_Distrikt LIKE 'Tyskland%'
)
THEN CAST(1 AS BIT)
ELSE CAST(0 AS BIT) END; 
