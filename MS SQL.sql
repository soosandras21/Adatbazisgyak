/*1. Készítsünk nézetet VSZOBA néven, amely megjeleníti a szobák adatai mellett a megfelelő szálláshely nevét, helyét és a csillagok számát is!

Az oszlopoknak nem szükséges külön nevet adni!
Teszteljük is a nézetet, pl: SELECT * FROM UJAENB_VSZOBA*/
Create or alter View VSZOBA
as
SELECT sz.*, szh.SZALLAS_NEV, szh.HELY, szh.CSILLAGOK_SZAMA
From szoba sz join szallashely szh on sz.SZALLAS_FK = szh.SZALLAS_ID

/*2 Készítsen tárolt eljárást SPUgyfelFoglalasok, amely a paraméterként megkapott ügyfél azonosítóhoz tartozó foglalások adatait listázza!
Teszteljük a tárolt eljárás működését, pl: EXEC UJAENB_SPUgyfelFoglalasok 'laszlo2'
*/

create or alter proc SPUgyfelFoglalasok
@ugyfel nvarchar(100)
as 
BEGIN
  select *
  from Foglalas
  Where ugyfel_fk = @ugyfel 
END

/*
3. Készítsen skalár értékű függvényt UDFFerohely néven, amely visszaadja, hogy a paraméterként megkapott foglalás azonosítóhoz hány férőhelyes szoba tartozik!
a. Teszteljük a függvény működését!
*/
Create or alter FUNCTION UDFFerohely
(
 @fazon int 
  )
RETURNS int 
AS 
BEGIN
declare @ferohely int 
SELect @ferohely = sz.FEROHELY
from foglalas f join szoba sz on f.SZOBA_FK = sz.SZOBA_ID
WHERE f.FOGLALAS_PK = @fazon 
RETURN @ferohely
END