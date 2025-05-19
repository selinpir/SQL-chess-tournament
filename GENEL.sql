--i�erik
  --sorgulama sorgular� :
   --view :
	--stored procedure : turnuva sonras� oyuncunun puan�n� hesaplar di�eri de ukd puan�n� g�nceller.
	 --trigger : yeni sporcu kayd�nda kurala g�re e posta atamas� yapar.
	  --table-valued function : oyuncunun ya��na g�re kategori dondurur.
	   --scaler valued function : turnuvaya kat�lan oyuncu say�s�, oyuncunun kat�ld�g� mac say�s� 
	    --yarat�m sorgular�
	     --a��klamalar
--********************************************************************************************************************************************
--sorgulama sorgular�
Select * from cinsiyet --lookup			  --+
Select * from hakem						  --+
Select * from kategori --lookup			  --+
Select * from oyuncu                      --+
Select * from sehir --lookup              --+     
Select * from turnuva                     --+
Select * from turnuvaHakem --aratablo	  --+
Select * from turnuvaKategori --aratablo  --+
Select * from turnuvaSistem --lookup      --+
Select * from turnuvaOyuncu               --+
Select * from mac						  --+				
Select * from macSonucTipi				  --+

----------------------------------------------------------------------------------------------------------------------------------------------
Select * from turnuva
Select * from hakem 
Select * from turnuvaHakem --aratablo (1 turnuvada birden �ok hakem olabilir g�rev t�rleri farkl�d�r) 
-- turnuvalara atanan hakemsay�lar�
SELECT t.turnuvaAd, COUNT(th.hakemID) AS hakemSayisi
from turnuva t
join turnuvaHakem th on t.turnuvaID = th.turnuvaID
GROUP BY t.turnuvaID, t.turnuvaAd;

--hi�bir turnuvaya atanamayan hakemler
SELECT h.ad, h.soyad
from hakem h
left join turnuvaHakem th on h.hakemID = th.hakemID --(hakem tablosundan t�m kay�tlar� al�r turnuva hakemde e�le�eni getirir- alttaki �artla e�le�meyeni getirir)
WHERE th.turnuvaID IS NULL;
----------------------------------------------------------------------------------------------------------------------------------------------
Select * from turnuva
Select * from kategori --(emektarlar=veteranlar!!)
Select * from turnuvaKategori

--turnuva ve kategori adlar� join
SELECT t.turnuvaAd, k.kategoriAd
from turnuvaKategori tk
join turnuva t on tk.turnuvaID = t.turnuvaID
join kategori k on tk.kategoriID = k.kategoriID;

--�niversitelere ait turnuvalar
Select t.turnuvaAd, t.baslangicTarihi,t.bitisTarihi,t.sehirID
from turnuvaKategori tk
join turnuva t on tk.turnuvaID=t.turnuvaID
join kategori k on tk.kategoriID = k.kategoriID
WHERE tk.kategoriID=3;
----------------------------------------------------------------------------------------------------------------------------------------------
Select * from oyuncu
Select * from cinsiyet
Select * from oyuncu where cinsiyetID=1
Select * from oyuncu where cinsiyetID=2
SELECT COUNT(*) FROM oyuncu WHERE cinsiyetID = 1;
SELECT COUNT(*) FROM oyuncu WHERE cinsiyetID = 2;

SELECT o.ad,o.soyad, c.cinsiyetID
FROM oyuncu o
JOIN cinsiyet c ON o.cinsiyetID = c.cinsiyetID;
----------------------------------------------------------------------------------------------------------------------------------------------
Select * from oyuncu
Select Upper(ad) ,soyad from oyuncu where oyuncuID=4

Select * from oyuncu where ad like '%u%'
Select * from oyuncu where soyad like '%k%y%'

Select ad,soyad,ukdPuan  from oyuncu ORDER BY ukdPuan ASC
Select ad,soyad,ukdPuan  from oyuncu ORDER BY ukdPuan DESC

Select * from oyuncu ORDER BY dogumTarihi ASC --en ya�l�dan en gence
Select TOP 1 * from oyuncu ORDER BY dogumTarihi DESC -- en gen� sporcu
Select TOP 1 * from oyuncu ORDER BY dogumTarihi ASC --en ya�l� sporcu

Select AVG(YEAR(GETDATE()) - YEAR(dogumTarihi)) AS ortalamaYas from oyuncu;

Select * from oyuncu where MONTH(dogumTarihi) = 8;
Select YEAR (dogumTarihi) AS dogumyili from oyuncu;
----------------------------------------------------------------------------------------------------------------------------------------------
Select * from sehir 
Select * from turnuva
--hangi �ehirde ka� turnuva yap�l�yor/acak? ve artan s�rada
select s.sehirAd, COUNT(t.turnuvaID) as turnuvaSayisi
from turnuva t
join sehir s on t.sehirID=s.sehirID
group by s.sehirAd  order by turnuvaSayisi asc
----------------------------------------------------------------------------------------------------------------------------------------------
Select * from turnuva        
Select LEN(turnuvaAd),turnuvaAd from turnuva --turnuva adlar�n�n uzunluklar�
Select REVERSE(turnuvaAd) as adTers ,REVERSE(yer) as yerTers from turnuva -- tersine cevirme metinleri

Select *from turnuva WHERE bitisTarihi < GETDATE(); --bitmi� turnuvalar
Select *from turnuva WHERE baslangicTarihi > GETDATE(); --gelecek turnuvalar
----------------------------------------------------------------------------------------------------------------------------------------------
Select * from turnuvaSistem 
Select * from turnuva
--turnuvalar�n sistemleri 
Select t.turnuvaAd, ts.sistemAd 
from turnuva t
join turnuvaSistem ts on t.sistemID=ts.sistemID

--her sistemle ka� turnuva yap�lm��?
Select ts.sistemAd, COUNT(t.turnuvaID) as turnuvaSayisi
from turnuva t
join turnuvaSistem ts on t.sistemID=ts.sistemID
group by ts.sistemAd
order by turnuvaSayisi 

--sadece isvicre sistemli turnuvalar� getir
Select t.turnuvaAd, t.baslangicTarihi, t.bitisTarihi ,t.yer, ts.sistemAd
from turnuva t
join turnuvaSistem ts on t.sistemID=ts.sistemID
where ts.sistemAd='�svicre Sistemi'
----------------------------------------------------------------------------------------------------------------------------------------------
Select * from mac

select t.turnuvaAd, k.kategoriad, rauntNo, o1.oyuncuID AS beyazOyuncu , o2.oyuncuID as siyahOyuncu, s.sonucAdi,h.ad
from mac m
join turnuva t on t.turnuvaID=m.turnuvaID
join kategori k on k.kategoriID=m.kategoriID
join oyuncu o1 on o1.oyuncuID=m.beyazOyuncuID
join oyuncu o2 on o2.oyuncuID=m.siyahOyuncuID
join macSonucTipi s on s.sonucID=m.sonucID
join hakem h on h.hakemID=m.hakemID

Select * from mac
join macSonucTipi on mac.sonucID=macSonucTipi.sonucID
----------------------------------------------------------------------------------------------------------------------------------------------
--sporcu aktif mi yani �ld� veya kat�lmaya devam edecek mi? aktif/pasif
--ALTER TABLE oyuncu
--ADD aktifMi BIT DEFAULT 1;

--UPDATE oyuncu
--SET aktifMi = 1;

select *from oyuncu where oyuncuID=29 

--UPDATE oyuncu
--SET aktifMi = 0
--WHERE oyuncuID = 29;

select ad, soyad , aktifMi from oyuncu
----------------------------------------------------------------------------------------------------------------------------------------------
--UPDATE oyuncu --soyad g�ncelleme
--SET soyad = 'AYMADIN'
--WHERE oyuncuID = 17;

SELECT * FROM oyuncu WHERE oyuncuID = 17;
----------------------------------------------------------------------------------------------------------------------------------------------
--INSERT INTO turnuva (turnuvaAd, baslangicTarihi, bitisTarihi, sehirID, yer, sistemID)
--VALUES
--('2025 Pamukkale A��k Satran� Turnuvas�', '2025-09-10', '2025-09-15', 20, 'Pamukkale �niversitesi Kongre Merkezi', 1);

--Delete from turnuva where turnuvaID=15

----------------------------------------------------------------------------------------------------------------------------------------------
Select * from turnuvaOyuncu  --turnuvalara kaydolan oyuncular
Select * from turnuvaOyuncu where oyuncuID=3 --�dsi 3 olan oyuncu �di 4 olan turnuvada oynam��t�r 
Select * from turnuvaOyuncu where puan=0

--stored procedure cali�tirmas
--EXEC sp_turnuvaPuanlariniHesapla @turnuvaID = 4;
--EXEC sp_turnuvaPuanlariniHesapla @turnuvaID = 5;
--EXEC sp_turnuvaPuanlariniHesapla @turnuvaID = 6;
--EXEC sp_turnuvaPuanlariniHesapla @turnuvaID = 8;
--EXEC sp_turnuvaPuanlariniHesapla @turnuvaID = 9;
--EXEC sp_turnuvaPuanlariniHesapla @turnuvaID = 10;

--EXEC sp_turnuvaUKDPuanlariniGuncelle @turnuvaID = 4;
--EXEC sp_turnuvaUKDPuanlariniGuncelle @turnuvaID = 5;
--EXEC sp_turnuvaUKDPuanlariniGuncelle @turnuvaID = 6;
--EXEC sp_turnuvaUKDPuanlariniGuncelle @turnuvaID = 8;
--EXEC sp_turnuvaUKDPuanlariniGuncelle @turnuvaID = 9;
--EXEC sp_turnuvaUKDPuanlariniGuncelle @turnuvaID = 10;

select * from oyuncu 
select * from turnuvaOyuncu where turnuvaID = 4; --kay�ttaki puan oldu�u i�in 1512
select * from oyuncu where oyuncuID IN (select oyuncuID from turnuvaOyuncu where turnuvaID = 4); -- �uan 1516 biraz fazla �al��t�rm���m
----------------------------------------------------------------------------------------------------------------------------------------------
--********************************************************************************************************************************************
--CREATE VIEW turnuvaMacGorunumu AS
--SELECT 
--    t.turnuvaAd, 
--    k.kategoriad, 
--    m.rauntNo, 
--    o1.oyuncuID AS beyazOyuncu, 
--    o2.oyuncuID AS siyahOyuncu, 
--    s.sonucAdi, 
--    h.ad AS hakemAd,
--	h.soyad AS hakemSoyad
--FROM mac m
--JOIN turnuva t ON t.turnuvaID = m.turnuvaID
--JOIN kategori k ON k.kategoriID = m.kategoriID
--JOIN oyuncu o1 ON o1.oyuncuID = m.beyazOyuncuID
--JOIN oyuncu o2 ON o2.oyuncuID = m.siyahOyuncuID
--JOIN macSonucTipi s ON s.sonucID = m.sonucID
--JOIN hakem h ON h.hakemID = m.hakemID;

select * from turnuvaMacGorunumu
select * from turnuvaMacGorunumu where sonucAdi='Beraberlik'
select * from turnuvaMacGorunumu where hakemAd='Rust' 
----------------------------------------------------------------------------------------------
--**VIEW2**
--CREATE VIEW vw_oyuncuBilgileri AS
--SELECT 
--    o.oyuncuID,
--    o.ad,
--    o.soyad,
--    o.dogumTarihi,
--    DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) AS yas,
--    o.ukdPuan,
--    o.ePosta,
--    o.telNo,
--    c.cinsiyet
--FROM oyuncu o
--JOIN cinsiyet c ON o.cinsiyetID = c.cinsiyetID;

select * from vw_oyuncuBilgileri
select * from vw_oyuncuBilgileri where yas=20 or yas=30
select * from vw_oyuncuBilgileri where ukdPuan BETWEEN 1000 AND 1200

--**********************STORED PROCEDURE******************************************************************************************************
--1-
--CREATE PROCEDURE sp_turnuvaPuanlariniHesapla
--    @turnuvaID BIGINT
--AS
--BEGIN
--    -- Turnuva oyuncular�n�n puanlar�n� s�f�rla
--    UPDATE turnuvaOyuncu
--    SET puan = 0
--    WHERE turnuvaID = @turnuvaID;

--    -- Beyaz oyunculara puan ekle
--    UPDATE to1
--    SET puan = puan + 
--        CASE 
--            WHEN m.sonucID IN (1, 4) THEN 1
--            WHEN m.sonucID = 3 THEN 0.5
--            ELSE 0
--        END
--    FROM turnuvaOyuncu to1
--    JOIN mac m ON m.turnuvaID = to1.turnuvaID AND m.beyazOyuncuID = to1.oyuncuID
--    WHERE to1.turnuvaID = @turnuvaID;

--    -- Siyah oyunculara puan ekle
--    UPDATE to2
--    SET puan = puan + 
--        CASE 
--            WHEN m.sonucID IN (2, 5) THEN 1
--            WHEN m.sonucID = 3 THEN 0.5
--            ELSE 0
--        END
--    FROM turnuvaOyuncu to2
--    JOIN mac m ON m.turnuvaID = to2.turnuvaID AND m.siyahOyuncuID = to2.oyuncuID
--    WHERE to2.turnuvaID = @turnuvaID;
--END

--2-
--CREATE PROCEDURE sp_turnuvaUKDPuanlariniGuncelle
--    @turnuvaID BIGINT
--AS
--BEGIN
--    ;WITH Puanlar AS (
--        SELECT oyuncuID, puan
--        FROM turnuvaOyuncu
--        WHERE turnuvaID = @turnuvaID
--    )
--    UPDATE o
--    SET o.ukdPuan = o.ukdPuan + p.puan
--    FROM oyuncu o
--    JOIN Puanlar p ON o.oyuncuID = p.oyuncuID;
--END


--********************************************************************************************************************************************

--****************************************TRIGGER*********************************************************************************************
--yeni sporcu kayd�nda trigger tetiklenerek e posta adresi olu�turacak

--CREATE TRIGGER trg_email_olustur
--ON oyuncu
--AFTER INSERT --yeni sporcu eklenince �al��acak
--AS
--BEGIN
--    UPDATE o --eposta not null oldugundan ba�ta atanan veri burda g�ncelleniyor
--    SET ePosta = LOWER(LEFT(i.ad, 1)) +
--                 LOWER(i.soyad) +
--                 '@cheesmail.com'
--    FROM oyuncu o
--    INNER JOIN inserted i ON o.oyuncuID = i.oyuncuID;
--END;
--********************************************************************************************************************************************

--******************************--TABLE-VALUED FUNCTION -tabloD�nd�ren--**********************************************************************
--Create Function dbo.OyuncuKategorileri(
--	@dogumTarihi Date,
--	@cinsiyetID INT )
--Returns @kategoriTablosu Table(
--	kategoriID INT)
--AS
--BEGIN
--	DECLARE @yas INT = DATEDIFF(Year,@dogumTarihi, GETDATE());
--	INSERT INTO @kategoriTablosu Values(1)		 -- genel kategori
--	IF @cinsiyetID=1
--		INSERT INTO @kategoriTablosu values(2)	 --kad�nlar kategorisine
--	IF @yas>=17 AND @yas<=25
--		INSERT INTO @kategoriTablosu values (3)	 --universite ��rencileri
--	IF @yas>=50 
--		INSERT INTO @kategoriTablosu values(4)   --veteran
--		--yasa g�re ..veAlti
--	IF @yas<=8
--		INSERT INTO @kategoriTablosu Values(5)
--	IF @yas<=10
--		INSERT INTO @kategoriTablosu values(6)
--    IF @yas <= 12
--        INSERT INTO @KategoriTablosu values (7)
--	IF @yas <= 14
--        INSERT INTO @KategoriTablosu values (8)
--    IF @yas <= 16
--        INSERT INTO @KategoriTablosu values (9)
--    IF @yas <= 18
--        INSERT INTO @KategoriTablosu values (10)

--    RETURN;
--END;
--GO
----------------------------------------------------------------------------------------------
--SELECT
--    o.oyuncuID,
--    o.ad + ' ' + o.soyad AS oyuncuAdSoyad,
--    DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) AS yas,    

--    1 AS Genel,     -- Genel Kategori
--    CASE WHEN o.cinsiyetID = 1 THEN 1 ELSE 0 END AS Kadinlar,														  -- Kad�nlar kategorisi (cinsiyetID = 1 ise 1, de�ilse 0)
--    CASE WHEN DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) BETWEEN 17 AND 25 THEN 1 ELSE 0 END AS UniversitelerArasi,   -- �niversiteleraras� (ya� 17-25 aras�)
--	CASE WHEN DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) >= 50 THEN 1 ELSE 0 END AS Veteranlar,						  -- Veteranlar (50+ ya�)
--    CASE WHEN DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) <= 8 THEN 1 ELSE 0 END AS Yas8VeAlti,						  -- 8 Ya� ve Alt�
--    CASE WHEN DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) <= 10 THEN 1 ELSE 0 END AS Yas10VeAlti,					  -- 10 Ya� ve Alt�
--	CASE WHEN DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) <= 12 THEN 1 ELSE 0 END AS Yas12VeAlti,						  -- 12 Ya� ve Alt�
--	CASE WHEN DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) <= 14 THEN 1 ELSE 0 END AS Yas14VeAlti,						  -- 14 Ya� ve Alt�
--    CASE WHEN DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) <= 16 THEN 1 ELSE 0 END AS Yas16VeAlti,					  -- 16 Ya� ve Alt�
--    CASE WHEN DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) <= 18 THEN 1 ELSE 0 END AS Yas18VeAlti						  -- 18 Ya� ve Alt�
--FROM oyuncu o;
--********************************************************************************************************************************************

--********************************SCALER VALUED FUNCTION**************************************************************************************
--turnuvaya kat�lan oyuncu say�s� scaler valued function
--CREATE FUNCTION turnuvaOyuncuSayisi (@turnuvaID BIGINT)
--RETURNS INT
--AS
--BEGIN
--    DECLARE @sayi INT
--    SELECT @sayi = COUNT(*) FROM turnuvaOyuncu WHERE turnuvaID = @turnuvaID
--    RETURN @sayi
--END


select dbo.turnuvaOyuncuSayisi(4) AS OyuncuSayisi
----------------------------------------------------------------------------------------------------------------------------------------------
--oyuncunun kat�ld�g� mac say�s� scaler valued function
--CREATE FUNCTION oyuncuMacSayisi
--(
--    @oyuncuID BIGINT
--)
--RETURNS INT
--AS
--BEGIN
--    DECLARE @macSayisi INT
--    SELECT @macSayisi = COUNT(*) 
--    FROM mac 
--    WHERE beyazOyuncuID = @oyuncuID OR siyahOyuncuID = @oyuncuID

--    RETURN ISNULL(@macSayisi, 0)
--END

select dbo.oyuncuMacSayisi(12) AS oyuncuMacSayisi
select dbo.oyuncuMacSayisi(23) AS oyuncuMacSayisi
--********************************************************************************************************************************************
--*yarat�m sorgular�*--
--CREATE TABLE turnuva (
--    turnuvaID bigint IDENTITY(1,1) PRIMARY KEY NOT NULL,               
--    turnuvaAd varchar(300) NOT NULL,         
--    baslangicTarihi date NOT NULL,           
--    bitisTarihi date NOT NULL,               
--    sehirID tinyint NOT NULL,                
--    yer varchar(300) NOT NULL,               
--    sistemID tinyint NOT NULL,           
--);
--**
--CREATE TABLE kategori (
--    kategoriID tinyint IDENTITY(1,1) PRIMARY KEY NOT NULL,               
--    kategoriAd varchar(150) NOT NULL,         
--    aciklama varchar(150) NULL,
--	minYas tinyint NULL,
--	maxYas tinyint NULL
--);
--**
--+ 1 turnuvan�n birden �ok kategorisi olabilir,genellikle ya� baz�nda.
--CREATE TABLE turnuvaKategori (
--    turnuvaID BIGINT NOT NULL,
--    kategoriID tinyint NOT NULL,
--    PRIMARY KEY (turnuvaID, kategoriID),
--    FOREIGN KEY (turnuvaID) REFERENCES turnuva(turnuvaID),
--    FOREIGN KEY (kategoriID) REFERENCES kategori(kategoriID)
--);
--**
--CREATE TABLE turnuvaSistem (
--    sistemID tinyint IDENTITY(1,1) PRIMARY KEY NOT NULL,               
--    sistemAd varchar(150) NOT NULL,         
--    aciklama varchar(150) NULL
--);
--**
--CREATE TABLE hakem (
--    hakemID int IDENTITY(1,1) PRIMARY KEY NOT NULL,  
--	ad varchar(100) NOT NULL,
--	soyad varchar(100) NOT NULL,
--	unvan varchar(50) NOT NULL,
--	lisansNoTSF int NOT NULL 
-- );
--**
--CREATE TABLE turnuvaHakem (
--    turnuvaID bigint NOT NULL,
--    hakemID int NOT NULL,
--    gorevTuru varchar(100), -- Ba�hakem, masa hakemi, yard�mc� hakem gibi
--    FOREIGN KEY (turnuvaID) REFERENCES turnuva(turnuvaID),
--    FOREIGN KEY (hakemID) REFERENCES hakem(hakemID)
--);
--**
--CREATE TABLE cinsiyet (
--    cinsiyetID tinyint IDENTITY(1,1) PRIMARY KEY NOT NULL,
--	cinsiyet varchar(10) NOT NULL
-- );
--**
-- CREATE TABLE oyuncu (
--    oyuncuID bigint IDENTITY(1,1) PRIMARY KEY NOT NULL,               
--    ad varchar(150) NOT NULL, 
--	soyad varchar(150) NOT NULL,
--	dogumTarihi date NOT NULL,
--	cinsiyetID tinyint NOT NULL,
--	ukdPuan int NOT NULL, --UKD (Ulusal Kuvvet Derecesi)
--	ePosta varchar(100) NOT NULL, 
--	telNo varchar(11)NOT NULL,
--	FOREIGN KEY (cinsiyetID) REFERENCES cinsiyet(cinsiyetID)
--);

--ALTER TABLE oyuncu
--ALTER COLUMN telNo varchar(14);
--**
--TURNUVA OYUNCU ARA TAB
--CREATE TABLE turnuvaOyuncu (
--    turnuvaID BIGINT NOT NULL, --turnuvan�n ID
--    oyuncuID BIGINT NOT NULL,  --oyuncunun ID
--    kategoriID TINYINT NOT NULL,   
--    kayitTarihi DATE DEFAULT GETDATE(), -- (Varsay�lan olarak kay�t an�) 
--    ukd INT,                   -- (Turnuvaya kat�ld��� zamanki UKD puan�) //float yap�ld� sonra
--    PRIMARY KEY (turnuvaID, oyuncuID),
--    FOREIGN KEY (turnuvaID) REFERENCES turnuva(turnuvaID),
--    FOREIGN KEY (oyuncuID) REFERENCES oyuncu(oyuncuID),
--    FOREIGN KEY (kategoriID) REFERENCES kategori(kategoriID)
--);
--ALTER TABLE turnuvaOyuncu
--ADD puan FLOAT DEFAULT 0;
--**
-- SONU� T�P� ���N LOOKUPT
--CREATE TABLE macSonucTipi (
--	sonucID tinyint IDENTITY(1,1) PRIMARY KEY NOT NULL,             
--	sonucAdi varchar(70) NOT NULL
--)
--**
--CREATE TABLE mac (
--    macID BIGINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
--    turnuvaID BIGINT NOT NULL,
--    kategoriID TINYINT NOT NULL,                    -- Ma��n ait oldu�u kategori 
--    rauntNo TINYINT NOT NULL,                       -- Raunt numaras� (1. raunt, 2. raunt...)
--    beyazOyuncuID BIGINT NOT NULL,                  -- Beyaz ta�la oynayan oyuncu
--    siyahOyuncuID BIGINT NOT NULL,                  -- Siyah ta�la oynayan oyuncu
--    sonucID TINYINT NOT NULL,                       -- ma� sonucu (macSonucTipi'den FK)
--    masaNo SMALLINT NOT NULL,                       -- Masa numaras� (e�le�ti�i masa)
--    aciklama VARCHAR(200) NULL,                     -- Gerekirse notlar
--    hakemID INT,                                    -- Ma�� y�neten hakem 

--    FOREIGN KEY (turnuvaID) REFERENCES turnuva(turnuvaID),
--    FOREIGN KEY (kategoriID) REFERENCES kategori(kategoriID), --kategoriID -> ayn� turnuvada birden fazla kategori olabilir. 
--    FOREIGN KEY (beyazOyuncuID) REFERENCES oyuncu(oyuncuID),
--    FOREIGN KEY (siyahOyuncuID) REFERENCES oyuncu(oyuncuID),
--    FOREIGN KEY (sonucID) REFERENCES macSonucTipi(sonucID),
--    FOREIGN KEY (hakemID) REFERENCES hakem(hakemID)
--);
--**
--+turnuvaSisteme veri ekleme
--INSERT INTO turnuvaSistem (sistemAD,aciklama)
--values 
--('�svicre Sistemi','Kazanan kazananla, kaybeden kaybedenle eslesir,5-9 tur aras� oynan�r.'),
--('Berger Sistemi','Az say�da kat�l�mc� gerekir,t�m oyuncular birbiriyle e�le�ir ve t�m oyuncular birbirlerine kar�� oynarlar.'),
--('Eleme Sistemi','Kaybeden elenir,kazanan bir �st tura ge�er.'),
--('H�zl� Satranc','Zamana kar�� ve h�zl� oynan�r.');

 --+hakem ekleme
--INSERT INTO hakem (ad,soyad,unvan,lisansNoTSF)
--values 
--('Rust','Cohle','ULUSAL',3171), --d�z ulusal hakem
--('Mart','Hart','IA',6873),
--('John','Reese','IA',12725), --IA uluslararas� hakem
--('Harold','Finch','ADAY',13616), --d�z aday hakemi
--('James','Ford','ADAY',3941),
--('Kate','Austen','�L',1044),
--('Benjamin','Linus','FA',12730),--FIDE Hakemi 
--('Alex','Drake','�L',14036),
--('Gene','Hunt','FA',12704),
--('Jack','Shephard','�L',1), --d�z il hakemi
--('Samantha','Groves','ADAY',7340);

 --INSERT INTO turnuvaHakem(turnuvaID,hakemID,gorevTuru)
 --Values
 --(1,9,'Ba�hakem'),
 --(3,3,'Yard�mc� hakem');

  --INSERT INTO cinsiyet(cinsiyet)
 --Values
 --('Kad�n'),
 --('Erkek');

 --INSERT INTO oyuncu(ad,soyad,dogumTarihi,cinsiyetID,ukdPuan,ePosta,telNo)
--values
--('DEN�Z','G�NAYDI'	,'2002-08-26',	1,	1512,	'dgunayd�@cheesmail.com',	'0532 768 42 19'),
--('Ula�','�INAR'		,'2015-07-25',	2,	1004,	'ucinar@cheesmail.com',		'0543 915 27 34'),
--('I�IL','�ZT�RK'	,'1985-03-25',	1,	1138,	'iozturk@cheesmail.com',	'0507 482 61 75'),
--('SARP','KILIN�'	,'2000-07-01',	2,	1146,	'skilinc@cheesmail.com',	'0555 132 48 06'),
--('BARI�','AYBARS'	,'1968-03-12',	2,	1330,	'baybars@cheesmail.com',	'0538 290 15 87'),
--('ZEYNEP','PARMAKSIZ','2019-05-15',	1,	1723,	'zparmaksiz@cheesmail.com',	'0506 327 94 20'),
--('ATA','B�NG�L'	,	'2006-11-22',		2,	1146,	'abingul@cheesmail.com',	'0542 870 36 11'),
--('TOPRAK','�A�LAYANLAR','2004-07-25',	2,	1116,	'tcaglayanlar@cheesmail.com','0551 469 82 53'),
--('KUZEY','KAYA'		,'2008-10-25	',	2,	2000,	'kkaya@cheesmail.com',		'0505 703 19 88'),
--('�BRAH�M','KUYUMCU','1999-01-01',	2,	1900,	'ikuyumcu@cheesmail.com'		,'0546 512 77 90');

--INSERT INTO oyuncu(ad,soyad,dogumTarihi,cinsiyetID,ukdPuan,ePosta,telNo)
--VALUES
--('ASLI','ON�K�','1995-06-21',1,1600,'x','05051234567'),
--('MEHMET','DEM�R','1988-03-14',2,1550,'x','05052345678'),
--('MERVE','KARATA�','1999-11-08',1,1420,'x','05053456789'),
--('DEN�Z','AYDIN','1990-07-12',1,1390,'x','05054567890'),
--('CAN','KO�','2005-04-18',2,1340,'x','05055678901'),
--('ARYA','�NL�','2004-09-30',1,1375,'x','05056789012'),
--('AREL','P�R','2017-02-10',2,1200,'x','05057890123'),
--('�EBNEM','�ZDEM�R','2016-05-20',1,1250,'x','05058901234'),
--('EM�RHAN','G�NER','2014-08-15',2,1300,'x','05059012345'),
--('BUKET','ACAR','2012-12-03',1,1280,'x','05050123456'),
--('KASIM','YILDIZ','2010-07-27',2,1350,'x','05051234568'),
--('PEL�N','KILI�','2008-10-14',1,1450,'x','05052345679'),
--('�MER','TA�','2006-03-01',2,1500,'x','05053456780'),
--('MEL�S','G�L','2003-01-25',1,1480,'x','05054567891'),
--('METE','ARI','1970-06-10',2,1520,'x','05055678902'),
--('FATMA','TUN�','1965-09-19',1,1470,'x','05056789013'),
--('HAKAN','I�IK','2001-11-11',2,1490,'x','05057890124'),
--('N�SAN','YAL�IN','2007-04-04',1,1465,'x','05058901235'),
--('AREL','KURT','2015-03-03',2,1290,'x','05059012346'),
--('PEL�N','KESK�N','2018-06-06',1,1210,'x','05050123457');

--INSERT INTO turnuva (turnuvaAd, baslangicTarihi, bitisTarihi, sehirID, yer, sistemID)
--values
--('T�RE �LKBAHAR SATRAN� TURNUVASI',								   	 '2025-05-02', '2025-05-02', 35,'U�ur Okullar� Tire Kamp�s�', 1),
--('G�ZELBAH�E SATRAN� GELENEKSEL 5.SATRAN� TURNUVASI',				 '2025-05-11', '2025-05-12', 35,'Yal� Mahallesi 59. Sokak No:10/A G�zelbah�e', 1),
--('2025 T�rkiye Emektarlar Satran� �ampiyonas�',						 '2025-05-17', '2025-05-23', 6, 'Atat�rk Satran� Merkezi', 1),
--('Mersin B�y�k�ehir Belediyesi 8. Uluslararas� Satran� Turnuvas�',   '2024-10-10', '2024-10-16', 33,'Mersin B�y�k�ehir Belediyesi', 4),
--('�stanbul A��k Satran� Turnuvas� 2024',							 '2024-11-15', '2024-11-20', 34,'�stanbul Kongre Merkezi', 2),
--('Ankara Gen�lik ve Spor �enli�i Satran� Turnuvas�',				 '2025-03-05', '2025-03-09', 6, 'Ankara Spor Salonu', 3),
--('Ege �niversitesi 25. Satran� �enli�i',							 '2025-04-10', '2025-04-15', 35,'Ege �niversitesi K�lt�r Merkezi', 1),
--('Antalya A��k Satran� Turnuvas�',									 '2024-12-01', '2024-12-07', 7, 'Antalya K�lt�r Merkezi', 4),
--('T�rkiye K���kler Satran� �ampiyonas�',							 '2025-02-14', '2025-02-18', 16,'Bursa Merinos Atat�rk Kongre Merkezi', 2);

--INSERT INTO turnuva (turnuvaAd, baslangicTarihi, bitisTarihi, sehirID, yer, sistemID)
--values
--('2025 T�rkiye Kul�pler Satran� �ampiyonas�', '2025-07-27', '2025-08-03', 20, 'Denizli Satran� Salonu', 2),
--('2025 �zmir T�p Bayram� Satran� Turnuvas�', '2025-03-15', '2025-03-16', 35, 'Ege Perla AVM', 1);

--INSERT INTO macSonucTipi(sonucAdi)
--values
--('Beyaz Kazand�'),		-- Beyaz kazand�: beyaza 1, siyaha 0
--('Siyah Kazand�'),		-- Siyah kazand�: siyaha 1, beyaza 0
--('Beraberlik'),			-- Beraberlik: her iki oyuncuya 0.5
--('H�kmen Beyaz'),		-- H�kmen: kazanana 1, rakibe 0
--('H�kmen Siyah'),		-- H�kmen: kazanana 1, rakibe 0
--('�ki Taraf Gelmedi');	-- �ki taraf gelmedi: her ikisine 0

--INSERT INTO turnuvaHakem(turnuvaID, hakemID,gorevTuru)
--values
--(4,	1,	'BA�HAKEM'),
--(4,	2,	'HAKEM'),
--(5,	3,	'HAKEM'),
--(6,	2,	'BA�HAKEM'),
--(6,	10,	'HAKEM'),
--(7,	6,	'HAKEM'),
--(8,	8,	'HAKEM'),
--(9,	9,	'HAKEM'),
--(10,	11,	'HAKEM'),
--(11,	5,	'HAKEM'),
--(12,	1,	'HAKEM'),
--(13,	5,	'BA�HAKEM YRD.'),
--(14,	4,	'HAKEM')

--INSERT INTO turnuvaKategori(turnuvaID,kategoriID)
--values
--(4,5),
--(4,6),
--(4,7),
--(5,1),
--(6,4),
--(7,1),
--(8,1),
--(8,2),
--(9,3),
--(9,1),
--(10,3),
--(11,1),
--(12,5),
--(12,6),
--(12,7),
--(12,8),
--(13,1),
--(14,1)

--triggeri tetiklemek i�in veri ekleme - eposta not null oldu�undan �uanl�k x verisi verildi
--INSERT INTO oyuncu (ad, soyad, dogumTarihi, cinsiyetID, ukdPuan, ePosta, telNo)
--VALUES ('SEL�N', 'P�R', '2002-06-28', 1, 1800, 'x', '05551112233');

--INSERT INTO mac (turnuvaID, kategoriID, rauntNo, beyazOyuncuID, siyahOyuncuID, sonucID, masaNo, aciklama, hakemID) 
--VALUES
--(4, 3, 1, 3, 5, 3, 1, '�lk raunt ma��', 1),
--(4, 5, 1, 8, 11, 2, 2, '�ocuklar kategorisi ma��', 2),
--(5, 1, 2, 13, 14, 1, 1, 'Kad�nlar kategorisi', 3),
--(6, 4, 1, 7, 28, 3, 3, 'Veteranlar ma��', 4),
--(10, 9, 1, 10, 9, 3, 1, '�niversite ��rencileri kar��la�mas�', 1),
--(8, 6, 1, 23, 21, 1, 2, 'K���k ya� kategorisi kar��la�mas�', 2),
--(9, 8, 1, 22, 32, 3, 1, 'Gen�lik �enli�i ilk raunt ma��', 3);

--INSERT INTO turnuvaOyuncu (turnuvaID, oyuncuID, kategoriID, ukd, puan) 
--VALUES 
--(4,3,3,1512,''),
--(4,5,3,1138,''),
--(5,8,5,1723,''),
--(5,11,5,2000,''),
--(6,7,4,1330,''),
--(6,28,4,1520,''),
--(10,10,9,1116,''),
--(10,9,9,1146,''),
--(8,23,6,1280,''),
--(8,21,6,1250,''),
--(9,22,8,1300,''),
--(9,32,8,1290,'')

--********************************************************************************************************************************************

----*--aciklamalar--*--
--Bu proje kapsam�nda, satran� turnuvalar�n�n y�netimini kolayla�t�rmak amac�yla ili�kisel bir veritaban� tasar�m� ger�ekle�tirdim. 
--Sistem; turnuvalar�n, oyuncular�n, hakemlerin, ma�lar�n ve kategorilerin kaydedilmesini ve takibini sa�lamaktad�r. 
--E�er bir veritaban� olmazsa, turnuvalar Excel veya ka��t �zerinde tutulmak zorunda kal�r ve bu y�netim problemleri yarat�r.

--TABLOLAR:
--TURNUVA(genel turnuva ilanlar�)
--KATEGOR�(turnuva kategorileri-LOOKUP)
--TURNUVAKATEGOR�(ARATABLO)
--TURNUVAS�STEM(turnuva sistemleri-LOOKUP)
--SEH�R(LOOKUP)
--HAKEM(genel hakem kay�tlar�)
--turnuvaHakem(ARATABLO)
--OYUNCU(genel oyuncu kay�tlar�)
--C�NS�YET(LOOKUP)
--turnuvaOyuncu(ARATABLO-turnuvaya kay�t tablosu olarak da kullan�l�yor)
--macSonucuTipi(lookup)
--MAC(mac tablosu)
--turnuvaSonu� (aratablo) 

--Her oyuncu bir turnuvaya yaln�zca bir kez kay�t olabilir.
--Bir oyuncu ayn� anda yaln�zca bir ma�ta yer alabilir. 
--Her ma�ta iki farkl� oyuncu bulunmal�d�r. Bir oyuncu kendiyle e�le�tirilemez.
--Her ma� bir hakem taraf�ndan g�zlemlenebilir.
--Turnuva tarihi ba�lamadan �nce oyuncu kay�tlar� tamamlanmal�d�r.
--Her turnuva bir �ehir, bir kategori ve bir sistem t�r� ile ili�kilendirilir.
--Her oyuncunun cinsiyeti ve do�um tarihi kay�tta belirtilmelidir.
--Sonu� bilgisi (kazanma, kaybetme, beraberlik) her ma� i�in kaydedilmelidir.
--Bir hakem birden fazla ma�ta g�rev alabilir ancak ayn� anda farkl� ma�larda bulunamaz.
--Her raunt, ilgili turnuvan�n i�inde olmal�d�r.
----*--aciklamalar son--*--