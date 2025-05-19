--içerik
  --sorgulama sorgularý :
   --view :
	--stored procedure : turnuva sonrasý oyuncunun puanýný hesaplar diðeri de ukd puanýný günceller.
	 --trigger : yeni sporcu kaydýnda kurala göre e posta atamasý yapar.
	  --table-valued function : oyuncunun yaþýna göre kategori dondurur.
	   --scaler valued function : turnuvaya katýlan oyuncu sayýsý, oyuncunun katýldýgý mac sayýsý 
	    --yaratým sorgularý
	     --açýklamalar
--********************************************************************************************************************************************
--sorgulama sorgularý
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
Select * from turnuvaHakem --aratablo (1 turnuvada birden çok hakem olabilir görev türleri farklýdýr) 
-- turnuvalara atanan hakemsayýlarý
SELECT t.turnuvaAd, COUNT(th.hakemID) AS hakemSayisi
from turnuva t
join turnuvaHakem th on t.turnuvaID = th.turnuvaID
GROUP BY t.turnuvaID, t.turnuvaAd;

--hiçbir turnuvaya atanamayan hakemler
SELECT h.ad, h.soyad
from hakem h
left join turnuvaHakem th on h.hakemID = th.hakemID --(hakem tablosundan tüm kayýtlarý alýr turnuva hakemde eþleþeni getirir- alttaki þartla eþleþmeyeni getirir)
WHERE th.turnuvaID IS NULL;
----------------------------------------------------------------------------------------------------------------------------------------------
Select * from turnuva
Select * from kategori --(emektarlar=veteranlar!!)
Select * from turnuvaKategori

--turnuva ve kategori adlarý join
SELECT t.turnuvaAd, k.kategoriAd
from turnuvaKategori tk
join turnuva t on tk.turnuvaID = t.turnuvaID
join kategori k on tk.kategoriID = k.kategoriID;

--üniversitelere ait turnuvalar
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

Select * from oyuncu ORDER BY dogumTarihi ASC --en yaþlýdan en gence
Select TOP 1 * from oyuncu ORDER BY dogumTarihi DESC -- en genç sporcu
Select TOP 1 * from oyuncu ORDER BY dogumTarihi ASC --en yaþlý sporcu

Select AVG(YEAR(GETDATE()) - YEAR(dogumTarihi)) AS ortalamaYas from oyuncu;

Select * from oyuncu where MONTH(dogumTarihi) = 8;
Select YEAR (dogumTarihi) AS dogumyili from oyuncu;
----------------------------------------------------------------------------------------------------------------------------------------------
Select * from sehir 
Select * from turnuva
--hangi þehirde kaç turnuva yapýlýyor/acak? ve artan sýrada
select s.sehirAd, COUNT(t.turnuvaID) as turnuvaSayisi
from turnuva t
join sehir s on t.sehirID=s.sehirID
group by s.sehirAd  order by turnuvaSayisi asc
----------------------------------------------------------------------------------------------------------------------------------------------
Select * from turnuva        
Select LEN(turnuvaAd),turnuvaAd from turnuva --turnuva adlarýnýn uzunluklarý
Select REVERSE(turnuvaAd) as adTers ,REVERSE(yer) as yerTers from turnuva -- tersine cevirme metinleri

Select *from turnuva WHERE bitisTarihi < GETDATE(); --bitmiþ turnuvalar
Select *from turnuva WHERE baslangicTarihi > GETDATE(); --gelecek turnuvalar
----------------------------------------------------------------------------------------------------------------------------------------------
Select * from turnuvaSistem 
Select * from turnuva
--turnuvalarýn sistemleri 
Select t.turnuvaAd, ts.sistemAd 
from turnuva t
join turnuvaSistem ts on t.sistemID=ts.sistemID

--her sistemle kaç turnuva yapýlmýþ?
Select ts.sistemAd, COUNT(t.turnuvaID) as turnuvaSayisi
from turnuva t
join turnuvaSistem ts on t.sistemID=ts.sistemID
group by ts.sistemAd
order by turnuvaSayisi 

--sadece isvicre sistemli turnuvalarý getir
Select t.turnuvaAd, t.baslangicTarihi, t.bitisTarihi ,t.yer, ts.sistemAd
from turnuva t
join turnuvaSistem ts on t.sistemID=ts.sistemID
where ts.sistemAd='Ýsvicre Sistemi'
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
--sporcu aktif mi yani öldü veya katýlmaya devam edecek mi? aktif/pasif
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
--UPDATE oyuncu --soyad güncelleme
--SET soyad = 'AYMADIN'
--WHERE oyuncuID = 17;

SELECT * FROM oyuncu WHERE oyuncuID = 17;
----------------------------------------------------------------------------------------------------------------------------------------------
--INSERT INTO turnuva (turnuvaAd, baslangicTarihi, bitisTarihi, sehirID, yer, sistemID)
--VALUES
--('2025 Pamukkale Açýk Satranç Turnuvasý', '2025-09-10', '2025-09-15', 20, 'Pamukkale Üniversitesi Kongre Merkezi', 1);

--Delete from turnuva where turnuvaID=15

----------------------------------------------------------------------------------------------------------------------------------------------
Select * from turnuvaOyuncu  --turnuvalara kaydolan oyuncular
Select * from turnuvaOyuncu where oyuncuID=3 --ýdsi 3 olan oyuncu ýdi 4 olan turnuvada oynamýþtýr 
Select * from turnuvaOyuncu where puan=0

--stored procedure caliþtirmas
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
select * from turnuvaOyuncu where turnuvaID = 4; --kayýttaki puan olduðu için 1512
select * from oyuncu where oyuncuID IN (select oyuncuID from turnuvaOyuncu where turnuvaID = 4); -- þuan 1516 biraz fazla çalýþtýrmýþým
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
--    -- Turnuva oyuncularýnýn puanlarýný sýfýrla
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
--yeni sporcu kaydýnda trigger tetiklenerek e posta adresi oluþturacak

--CREATE TRIGGER trg_email_olustur
--ON oyuncu
--AFTER INSERT --yeni sporcu eklenince çalýþacak
--AS
--BEGIN
--    UPDATE o --eposta not null oldugundan baþta atanan veri burda güncelleniyor
--    SET ePosta = LOWER(LEFT(i.ad, 1)) +
--                 LOWER(i.soyad) +
--                 '@cheesmail.com'
--    FROM oyuncu o
--    INNER JOIN inserted i ON o.oyuncuID = i.oyuncuID;
--END;
--********************************************************************************************************************************************

--******************************--TABLE-VALUED FUNCTION -tabloDöndüren--**********************************************************************
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
--		INSERT INTO @kategoriTablosu values(2)	 --kadýnlar kategorisine
--	IF @yas>=17 AND @yas<=25
--		INSERT INTO @kategoriTablosu values (3)	 --universite öðrencileri
--	IF @yas>=50 
--		INSERT INTO @kategoriTablosu values(4)   --veteran
--		--yasa göre ..veAlti
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
--    CASE WHEN o.cinsiyetID = 1 THEN 1 ELSE 0 END AS Kadinlar,														  -- Kadýnlar kategorisi (cinsiyetID = 1 ise 1, deðilse 0)
--    CASE WHEN DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) BETWEEN 17 AND 25 THEN 1 ELSE 0 END AS UniversitelerArasi,   -- Üniversitelerarasý (yaþ 17-25 arasý)
--	CASE WHEN DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) >= 50 THEN 1 ELSE 0 END AS Veteranlar,						  -- Veteranlar (50+ yaþ)
--    CASE WHEN DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) <= 8 THEN 1 ELSE 0 END AS Yas8VeAlti,						  -- 8 Yaþ ve Altý
--    CASE WHEN DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) <= 10 THEN 1 ELSE 0 END AS Yas10VeAlti,					  -- 10 Yaþ ve Altý
--	CASE WHEN DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) <= 12 THEN 1 ELSE 0 END AS Yas12VeAlti,						  -- 12 Yaþ ve Altý
--	CASE WHEN DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) <= 14 THEN 1 ELSE 0 END AS Yas14VeAlti,						  -- 14 Yaþ ve Altý
--    CASE WHEN DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) <= 16 THEN 1 ELSE 0 END AS Yas16VeAlti,					  -- 16 Yaþ ve Altý
--    CASE WHEN DATEDIFF(YEAR, o.dogumTarihi, GETDATE()) <= 18 THEN 1 ELSE 0 END AS Yas18VeAlti						  -- 18 Yaþ ve Altý
--FROM oyuncu o;
--********************************************************************************************************************************************

--********************************SCALER VALUED FUNCTION**************************************************************************************
--turnuvaya katýlan oyuncu sayýsý scaler valued function
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
--oyuncunun katýldýgý mac sayýsý scaler valued function
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
--*yaratým sorgularý*--
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
--+ 1 turnuvanýn birden çok kategorisi olabilir,genellikle yaþ bazýnda.
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
--    gorevTuru varchar(100), -- Baþhakem, masa hakemi, yardýmcý hakem gibi
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
--    turnuvaID BIGINT NOT NULL, --turnuvanýn ID
--    oyuncuID BIGINT NOT NULL,  --oyuncunun ID
--    kategoriID TINYINT NOT NULL,   
--    kayitTarihi DATE DEFAULT GETDATE(), -- (Varsayýlan olarak kayýt aný) 
--    ukd INT,                   -- (Turnuvaya katýldýðý zamanki UKD puaný) //float yapýldý sonra
--    PRIMARY KEY (turnuvaID, oyuncuID),
--    FOREIGN KEY (turnuvaID) REFERENCES turnuva(turnuvaID),
--    FOREIGN KEY (oyuncuID) REFERENCES oyuncu(oyuncuID),
--    FOREIGN KEY (kategoriID) REFERENCES kategori(kategoriID)
--);
--ALTER TABLE turnuvaOyuncu
--ADD puan FLOAT DEFAULT 0;
--**
-- SONUÇ TÝPÝ ÝÇÝN LOOKUPT
--CREATE TABLE macSonucTipi (
--	sonucID tinyint IDENTITY(1,1) PRIMARY KEY NOT NULL,             
--	sonucAdi varchar(70) NOT NULL
--)
--**
--CREATE TABLE mac (
--    macID BIGINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
--    turnuvaID BIGINT NOT NULL,
--    kategoriID TINYINT NOT NULL,                    -- Maçýn ait olduðu kategori 
--    rauntNo TINYINT NOT NULL,                       -- Raunt numarasý (1. raunt, 2. raunt...)
--    beyazOyuncuID BIGINT NOT NULL,                  -- Beyaz taþla oynayan oyuncu
--    siyahOyuncuID BIGINT NOT NULL,                  -- Siyah taþla oynayan oyuncu
--    sonucID TINYINT NOT NULL,                       -- maç sonucu (macSonucTipi'den FK)
--    masaNo SMALLINT NOT NULL,                       -- Masa numarasý (eþleþtiði masa)
--    aciklama VARCHAR(200) NULL,                     -- Gerekirse notlar
--    hakemID INT,                                    -- Maçý yöneten hakem 

--    FOREIGN KEY (turnuvaID) REFERENCES turnuva(turnuvaID),
--    FOREIGN KEY (kategoriID) REFERENCES kategori(kategoriID), --kategoriID -> ayný turnuvada birden fazla kategori olabilir. 
--    FOREIGN KEY (beyazOyuncuID) REFERENCES oyuncu(oyuncuID),
--    FOREIGN KEY (siyahOyuncuID) REFERENCES oyuncu(oyuncuID),
--    FOREIGN KEY (sonucID) REFERENCES macSonucTipi(sonucID),
--    FOREIGN KEY (hakemID) REFERENCES hakem(hakemID)
--);
--**
--+turnuvaSisteme veri ekleme
--INSERT INTO turnuvaSistem (sistemAD,aciklama)
--values 
--('Ýsvicre Sistemi','Kazanan kazananla, kaybeden kaybedenle eslesir,5-9 tur arasý oynanýr.'),
--('Berger Sistemi','Az sayýda katýlýmcý gerekir,tüm oyuncular birbiriyle eþleþir ve tüm oyuncular birbirlerine karþý oynarlar.'),
--('Eleme Sistemi','Kaybeden elenir,kazanan bir üst tura geçer.'),
--('Hýzlý Satranc','Zamana karþý ve hýzlý oynanýr.');

 --+hakem ekleme
--INSERT INTO hakem (ad,soyad,unvan,lisansNoTSF)
--values 
--('Rust','Cohle','ULUSAL',3171), --düz ulusal hakem
--('Mart','Hart','IA',6873),
--('John','Reese','IA',12725), --IA uluslararasý hakem
--('Harold','Finch','ADAY',13616), --düz aday hakemi
--('James','Ford','ADAY',3941),
--('Kate','Austen','ÝL',1044),
--('Benjamin','Linus','FA',12730),--FIDE Hakemi 
--('Alex','Drake','ÝL',14036),
--('Gene','Hunt','FA',12704),
--('Jack','Shephard','ÝL',1), --düz il hakemi
--('Samantha','Groves','ADAY',7340);

 --INSERT INTO turnuvaHakem(turnuvaID,hakemID,gorevTuru)
 --Values
 --(1,9,'Baþhakem'),
 --(3,3,'Yardýmcý hakem');

  --INSERT INTO cinsiyet(cinsiyet)
 --Values
 --('Kadýn'),
 --('Erkek');

 --INSERT INTO oyuncu(ad,soyad,dogumTarihi,cinsiyetID,ukdPuan,ePosta,telNo)
--values
--('DENÝZ','GÜNAYDI'	,'2002-08-26',	1,	1512,	'dgunaydý@cheesmail.com',	'0532 768 42 19'),
--('Ulaþ','ÇINAR'		,'2015-07-25',	2,	1004,	'ucinar@cheesmail.com',		'0543 915 27 34'),
--('IÞIL','ÖZTÜRK'	,'1985-03-25',	1,	1138,	'iozturk@cheesmail.com',	'0507 482 61 75'),
--('SARP','KILINÇ'	,'2000-07-01',	2,	1146,	'skilinc@cheesmail.com',	'0555 132 48 06'),
--('BARIÞ','AYBARS'	,'1968-03-12',	2,	1330,	'baybars@cheesmail.com',	'0538 290 15 87'),
--('ZEYNEP','PARMAKSIZ','2019-05-15',	1,	1723,	'zparmaksiz@cheesmail.com',	'0506 327 94 20'),
--('ATA','BÝNGÜL'	,	'2006-11-22',		2,	1146,	'abingul@cheesmail.com',	'0542 870 36 11'),
--('TOPRAK','ÇAÐLAYANLAR','2004-07-25',	2,	1116,	'tcaglayanlar@cheesmail.com','0551 469 82 53'),
--('KUZEY','KAYA'		,'2008-10-25	',	2,	2000,	'kkaya@cheesmail.com',		'0505 703 19 88'),
--('ÝBRAHÝM','KUYUMCU','1999-01-01',	2,	1900,	'ikuyumcu@cheesmail.com'		,'0546 512 77 90');

--INSERT INTO oyuncu(ad,soyad,dogumTarihi,cinsiyetID,ukdPuan,ePosta,telNo)
--VALUES
--('ASLI','ONÝKÝ','1995-06-21',1,1600,'x','05051234567'),
--('MEHMET','DEMÝR','1988-03-14',2,1550,'x','05052345678'),
--('MERVE','KARATAÞ','1999-11-08',1,1420,'x','05053456789'),
--('DENÝZ','AYDIN','1990-07-12',1,1390,'x','05054567890'),
--('CAN','KOÇ','2005-04-18',2,1340,'x','05055678901'),
--('ARYA','ÜNLÜ','2004-09-30',1,1375,'x','05056789012'),
--('AREL','PÝR','2017-02-10',2,1200,'x','05057890123'),
--('ÞEBNEM','ÖZDEMÝR','2016-05-20',1,1250,'x','05058901234'),
--('EMÝRHAN','GÜNER','2014-08-15',2,1300,'x','05059012345'),
--('BUKET','ACAR','2012-12-03',1,1280,'x','05050123456'),
--('KASIM','YILDIZ','2010-07-27',2,1350,'x','05051234568'),
--('PELÝN','KILIÇ','2008-10-14',1,1450,'x','05052345679'),
--('ÖMER','TAÞ','2006-03-01',2,1500,'x','05053456780'),
--('MELÝS','GÜL','2003-01-25',1,1480,'x','05054567891'),
--('METE','ARI','1970-06-10',2,1520,'x','05055678902'),
--('FATMA','TUNÇ','1965-09-19',1,1470,'x','05056789013'),
--('HAKAN','IÞIK','2001-11-11',2,1490,'x','05057890124'),
--('NÝSAN','YALÇIN','2007-04-04',1,1465,'x','05058901235'),
--('AREL','KURT','2015-03-03',2,1290,'x','05059012346'),
--('PELÝN','KESKÝN','2018-06-06',1,1210,'x','05050123457');

--INSERT INTO turnuva (turnuvaAd, baslangicTarihi, bitisTarihi, sehirID, yer, sistemID)
--values
--('TÝRE ÝLKBAHAR SATRANÇ TURNUVASI',								   	 '2025-05-02', '2025-05-02', 35,'Uður Okullarý Tire Kampüsü', 1),
--('GÜZELBAHÇE SATRANÇ GELENEKSEL 5.SATRANÇ TURNUVASI',				 '2025-05-11', '2025-05-12', 35,'Yalý Mahallesi 59. Sokak No:10/A Güzelbahçe', 1),
--('2025 Türkiye Emektarlar Satranç Þampiyonasý',						 '2025-05-17', '2025-05-23', 6, 'Atatürk Satranç Merkezi', 1),
--('Mersin Büyükþehir Belediyesi 8. Uluslararasý Satranç Turnuvasý',   '2024-10-10', '2024-10-16', 33,'Mersin Büyükþehir Belediyesi', 4),
--('Ýstanbul Açýk Satranç Turnuvasý 2024',							 '2024-11-15', '2024-11-20', 34,'Ýstanbul Kongre Merkezi', 2),
--('Ankara Gençlik ve Spor Þenliði Satranç Turnuvasý',				 '2025-03-05', '2025-03-09', 6, 'Ankara Spor Salonu', 3),
--('Ege Üniversitesi 25. Satranç Þenliði',							 '2025-04-10', '2025-04-15', 35,'Ege Üniversitesi Kültür Merkezi', 1),
--('Antalya Açýk Satranç Turnuvasý',									 '2024-12-01', '2024-12-07', 7, 'Antalya Kültür Merkezi', 4),
--('Türkiye Küçükler Satranç Þampiyonasý',							 '2025-02-14', '2025-02-18', 16,'Bursa Merinos Atatürk Kongre Merkezi', 2);

--INSERT INTO turnuva (turnuvaAd, baslangicTarihi, bitisTarihi, sehirID, yer, sistemID)
--values
--('2025 Türkiye Kulüpler Satranç Þampiyonasý', '2025-07-27', '2025-08-03', 20, 'Denizli Satranç Salonu', 2),
--('2025 Ýzmir Týp Bayramý Satranç Turnuvasý', '2025-03-15', '2025-03-16', 35, 'Ege Perla AVM', 1);

--INSERT INTO macSonucTipi(sonucAdi)
--values
--('Beyaz Kazandý'),		-- Beyaz kazandý: beyaza 1, siyaha 0
--('Siyah Kazandý'),		-- Siyah kazandý: siyaha 1, beyaza 0
--('Beraberlik'),			-- Beraberlik: her iki oyuncuya 0.5
--('Hükmen Beyaz'),		-- Hükmen: kazanana 1, rakibe 0
--('Hükmen Siyah'),		-- Hükmen: kazanana 1, rakibe 0
--('Ýki Taraf Gelmedi');	-- Ýki taraf gelmedi: her ikisine 0

--INSERT INTO turnuvaHakem(turnuvaID, hakemID,gorevTuru)
--values
--(4,	1,	'BAÞHAKEM'),
--(4,	2,	'HAKEM'),
--(5,	3,	'HAKEM'),
--(6,	2,	'BAÞHAKEM'),
--(6,	10,	'HAKEM'),
--(7,	6,	'HAKEM'),
--(8,	8,	'HAKEM'),
--(9,	9,	'HAKEM'),
--(10,	11,	'HAKEM'),
--(11,	5,	'HAKEM'),
--(12,	1,	'HAKEM'),
--(13,	5,	'BAÞHAKEM YRD.'),
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

--triggeri tetiklemek için veri ekleme - eposta not null olduðundan þuanlýk x verisi verildi
--INSERT INTO oyuncu (ad, soyad, dogumTarihi, cinsiyetID, ukdPuan, ePosta, telNo)
--VALUES ('SELÝN', 'PÝR', '2002-06-28', 1, 1800, 'x', '05551112233');

--INSERT INTO mac (turnuvaID, kategoriID, rauntNo, beyazOyuncuID, siyahOyuncuID, sonucID, masaNo, aciklama, hakemID) 
--VALUES
--(4, 3, 1, 3, 5, 3, 1, 'Ýlk raunt maçý', 1),
--(4, 5, 1, 8, 11, 2, 2, 'Çocuklar kategorisi maçý', 2),
--(5, 1, 2, 13, 14, 1, 1, 'Kadýnlar kategorisi', 3),
--(6, 4, 1, 7, 28, 3, 3, 'Veteranlar maçý', 4),
--(10, 9, 1, 10, 9, 3, 1, 'Üniversite öðrencileri karþýlaþmasý', 1),
--(8, 6, 1, 23, 21, 1, 2, 'Küçük yaþ kategorisi karþýlaþmasý', 2),
--(9, 8, 1, 22, 32, 3, 1, 'Gençlik þenliði ilk raunt maçý', 3);

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
--Bu proje kapsamýnda, satranç turnuvalarýnýn yönetimini kolaylaþtýrmak amacýyla iliþkisel bir veritabaný tasarýmý gerçekleþtirdim. 
--Sistem; turnuvalarýn, oyuncularýn, hakemlerin, maçlarýn ve kategorilerin kaydedilmesini ve takibini saðlamaktadýr. 
--Eðer bir veritabaný olmazsa, turnuvalar Excel veya kaðýt üzerinde tutulmak zorunda kalýr ve bu yönetim problemleri yaratýr.

--TABLOLAR:
--TURNUVA(genel turnuva ilanlarý)
--KATEGORÝ(turnuva kategorileri-LOOKUP)
--TURNUVAKATEGORÝ(ARATABLO)
--TURNUVASÝSTEM(turnuva sistemleri-LOOKUP)
--SEHÝR(LOOKUP)
--HAKEM(genel hakem kayýtlarý)
--turnuvaHakem(ARATABLO)
--OYUNCU(genel oyuncu kayýtlarý)
--CÝNSÝYET(LOOKUP)
--turnuvaOyuncu(ARATABLO-turnuvaya kayýt tablosu olarak da kullanýlýyor)
--macSonucuTipi(lookup)
--MAC(mac tablosu)
--turnuvaSonuç (aratablo) 

--Her oyuncu bir turnuvaya yalnýzca bir kez kayýt olabilir.
--Bir oyuncu ayný anda yalnýzca bir maçta yer alabilir. 
--Her maçta iki farklý oyuncu bulunmalýdýr. Bir oyuncu kendiyle eþleþtirilemez.
--Her maç bir hakem tarafýndan gözlemlenebilir.
--Turnuva tarihi baþlamadan önce oyuncu kayýtlarý tamamlanmalýdýr.
--Her turnuva bir þehir, bir kategori ve bir sistem türü ile iliþkilendirilir.
--Her oyuncunun cinsiyeti ve doðum tarihi kayýtta belirtilmelidir.
--Sonuç bilgisi (kazanma, kaybetme, beraberlik) her maç için kaydedilmelidir.
--Bir hakem birden fazla maçta görev alabilir ancak ayný anda farklý maçlarda bulunamaz.
--Her raunt, ilgili turnuvanýn içinde olmalýdýr.
----*--aciklamalar son--*--