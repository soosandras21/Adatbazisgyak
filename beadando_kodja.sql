
CREATE TABLE Csapatok (
    csapat_id INT PRIMARY KEY,
    nev VARCHAR(100),
    varos VARCHAR(100)
);

INSERT INTO Csapatok (csapat_id, nev, varos) VALUES
    (1, 'Franciaország', 'Párizs'),
    (2, 'Németország', 'Berlin'),
    (3, 'Spanyolország', 'Madrid'),
    (4, 'Olaszország', 'Róma'),
    (5, 'Anglia', 'London');

CREATE TABLE Jatekosok (
    jatekos_id INT PRIMARY KEY,
    nev VARCHAR(100),
    pozicio VARCHAR(50),
    csapat_id INT,
    FOREIGN KEY (csapat_id) REFERENCES Csapatok(csapat_id)
);

INSERT INTO Jatekosok (jatekos_id, nev, pozicio, csapat_id) VALUES
    (1, 'Kylian Mbappé', 'Támadó', 1),
    (2, 'Manuel Neuer', 'Kapus', 2),
    (3, 'Sergio Ramos', 'Védő', 3),
    (4, 'Gianluigi Buffon', 'Kapus', 4),
    (5, 'Harry Kane', 'Támadó', 5);

CREATE TABLE Jatekvezetok (
    jv_id INT PRIMARY KEY,
    nev VARCHAR(100),
    szuletesi_datum DATE,
    orszag VARCHAR(100)
);

INSERT INTO Jatekvezetok (jv_id, nev, szuletesi_datum, orszag) VALUES
    (1, 'John Smith', '1980-05-15', 'Anglia'),
    (2, 'Maria Garcia', '1975-12-20', 'Spanyolország'),
    (3, 'Andreas Müller', '1982-08-10', 'Németország');



CREATE TABLE Merkozesek (
    merkozes_id INT PRIMARY KEY,
    datum DATE,
    helyszin VARCHAR(100),
    hazai_csapat_id INT,
    vendeg_csapat_id INT,
    jatekvezeto_id INT,
    FOREIGN KEY (hazai_csapat_id) REFERENCES Csapatok(csapat_id),
    FOREIGN KEY (vendeg_csapat_id) REFERENCES Csapatok(csapat_id),
    FOREIGN KEY (jatekvezeto_id) REFERENCES Jatekvezetok(jv_id)
);

INSERT INTO Merkozesek (merkozes_id, datum, helyszin, hazai_csapat_id, vendeg_csapat_id, jatekvezeto_id) VALUES
    (1, '2022-06-01', 'Budapest', 1, 2, 1),
    (2, '2022-06-02', 'München', 3, 4, 2),
    (3, '2022-06-03', 'Párizs', 5, 1, 3);

CREATE TABLE Golok (
    gol_id INT PRIMARY KEY,
    merkozes_id INT,
    idopont TIME,
    jatekos_id INT,
    FOREIGN KEY (merkozes_id) REFERENCES Merkozesek(merkozes_id),
    FOREIGN KEY (jatekos_id) REFERENCES Jatekosok(jatekos_id)
);

INSERT INTO Golok (gol_id, merkozes_id, idopont, jatekos_id) VALUES
    (1, 1, '18:32:00', 1),
    (2, 1, '20:12:00', 2),
    (3, 2, '19:45:00', 3),
    (4, 3, '21:10:00', 4); 


--1 összes capat játékosai pozíciókkal
/*
SELECT c.nev AS csapat_nev, j.nev AS jatekos_nev, j.pozicio
FROM Csapatok c
JOIN Jatekosok j ON c.csapat_id = j.csapat_id;
*/

--2 összes gól, csapatok összes gólja 
/*
SELECT
    m.merkozes_id,
    m.datum,
    m.helyszin,
    c.nev AS hazai_csapat,
    c2.nev AS vendeg_csapat,
    COUNT(g.gol_id) AS osszes_gol,
    SUM(CASE WHEN c.csapat_id = m.hazai_csapat_id THEN 1 ELSE 0 END) AS hazai_csapat_gol,
    SUM(CASE WHEN c2.csapat_id = m.vendeg_csapat_id THEN 1 ELSE 0 END) AS vendeg_csapat_gol
FROM
    Merkozesek m
LEFT JOIN
    Csapatok c ON m.hazai_csapat_id = c.csapat_id
LEFT JOIN
    Csapatok c2 ON m.vendeg_csapat_id = c2.csapat_id
LEFT JOIN
    Golok g ON m.merkozes_id = g.merkozes_id
GROUP BY rollup(
    m.merkozes_id, m.datum, m.helyszin, c.nev, c2.nev ) 
    */

--3 gólszerzők toplistája
/*
SELECT
    j.nev AS jatekos_nev,
    COUNT(g.gol_id) AS golok_szama
FROM
    Jatekosok j
JOIN
    Golok g ON j.jatekos_id = g.jatekos_id
GROUP BY
    j.nev
ORDER BY
    COUNT(g.gol_id) DESC; 
    */
    
--4 játékvezetők országonként
/*
SELECT
    orszag,
    COUNT(jv_id) AS jatekvezetok_szama
FROM
    Jatekvezetok
GROUP BY
    orszag;
    */
    
--5 összes meccs minden adattal
/*
SELECT
    m.merkozes_id,
    m.datum,
    m.helyszin,
    hazai.nev AS hazai_csapat,
    vendeg.nev AS vendeg_csapat,
    jv.nev AS jatekvezeto
FROM
    Merkozesek m
JOIN
    Csapatok hazai ON m.hazai_csapat_id = hazai.csapat_id
JOIN
    Csapatok vendeg ON m.vendeg_csapat_id = vendeg.csapat_id
LEFT JOIN
    Jatekvezetok jv ON m.jatekvezeto_id = jv.jv_id;
*/

--6 ranksorolás hónapok szerinti csoportosításban
SELECT
    datum,
    hazai_csapat,
    vendeg_csapat,
    RANK() OVER (PARTITION BY MONTH(datum) ORDER BY datum) AS helyezes_a_honapban
FROM
    (
        SELECT
            m.datum,
            hazai.nev AS hazai_csapat,
            vendeg.nev AS vendeg_csapat
        FROM
            Merkozesek m
        JOIN
            Csapatok hazai ON m.hazai_csapat_id = hazai.csapat_id
        JOIN
            Csapatok vendeg ON m.vendeg_csapat_id = vendeg.csapat_id
    ) AS merkozesek;




