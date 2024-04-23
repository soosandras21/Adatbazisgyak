CREATE table maszkolas
(usernev nvarchar(40),
 nev nvarchar(100) masked with (Function = 'partial(1,"XXX",1)'),
 email nvarchar(120) masked with (Function = 'email()'),
 szaml_cim nvarchar(200),
 szul_dat date,
 gyerekszam int masked with (Function = 'random(1,5)')
 )
 
 Insert into maszkolas
 (usernev, nev, email, szaml_cim, szul_dat)
 select usernev, nev, email, szaml_cim, szul_dat
 from Vendeg
 
 update maszkolas set gyerekszam = 2 
 

 
 
CREATE USER MaskUser WITHOUT Login;
GRANT SELECT ON maszkolas TO MaskUser
 
 EXECUTE AS User= 'MaskUser';
SELECT * FROM maszkolas
REVERT
 






