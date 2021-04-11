
[![rickroll](https://cldup.com/dTxpPi9lDf.thumb.png)](https://www.youtube.com/watch?v=dQw4w9WgXcQ)



## npc_hero_nicknames
keď hráč postupuje levelmi a spĺňa hlavné úlohy tak postupne prechádza míľnikmi, ktoré mu prinášajú tituly. Môže to byť napríklad zabitie bossa, nájdenie špeciálneho predmetu alebo zúčastnenie sa na nejakom evente, kde daný hrdina niečo dokázal. Tituly si hrdina nevie zmeniť v nastavení hry, aby aj v takto fantazíjnej hre zostal nejaký racionálny rozum. Predsa len, keby sme dokázali sa prezývať inak, tak by sme to museli povedať každej osobe v našom hernom svete. Chceme preto ponechať roleplay zážitok a preto sa tituly budú viazať k nejakému míľniku. Tituly budú používané nehratelnými postavami a aby zostala nejaká variácia titulov, tak každá rasa + pohlavie bude mať na výber iné tituly a pri míľnikoch, ktoré musí splniť každá postava budú občasné variácie. 

<br />





# USER SECTION

## user
najhlavnejšia tabulka v sekcií užívateľov. ukladá nám informácie o koncovom užívateľovi. 
**realname** - meno,  budeme užívateľa oslovovať mimo hru (email, newsletter)
**username** - prihlasovacie meno
**nickname** - prezývka, ktorú si nastavil (pr. steam, username zostáva taký istý, nick nie)
**password_hash** - heslo nebude ukladané ako plaintext ale ako sha256 hash aby aj "nbusr123" malo ako takú ochranu ( dlžka sha256 hashu - 32byte)
**email** - dlhy 64 (user) + @ + 255 (domain) = 320 (**podla RFC 5322**)


## login_logs
v tejto tabuľke sa ukladajú všetky úspešné prihlasovania do účtu. presnejšie sa ukladá užívateľské meno, čas loginu a login data. Login data si môžeme predstaviť ako užitočné informácie pre nás z payloadu -> napr. z akej IP adresy sa user prihlásil a miesto aby logika mohla vyhodnotiť či bude treba verifikovať usera aj iným spôsobom ako heslom. 
**example** steam verifikácia keď sa prihlási z nového zariadenia

## user_permissions
tabulka, ktorá nám hovorí o právomociach užívateľa. Každý sa prihlási ako obyčajný user a potom sa mu pridelí rola napr. admin/hráč.

## user_relationship
tabulka, kde sú uložené všetky vzťahy užívateľov. V momentálnej situácií to je priateľstvo, ignorovanie "správ" na predídenie spamu a block. Ak by sme chceli expandovať hru a túto tabulku, tak by sme mohli pridať napríklad koľko súbojov prebehlo medzi týmito postavami. Je to asociačná tabuľka medzi dvoma hrdinami. 

## friend_requests
tabulka, ktorá nám ukladá všetky pozvánky priateľstva. Priateľstvo vzniká medzi dvomi hráčmi a nie medzi dvomi hrdinami, čo je výhodnejšie pre samotného koncového užívateľa


# TEAM SECTION
do tejto sekcií spadájú tabuľky, ktoré pracujú s tímami. 

## team_members
asociačná tabuľka medzi tímami a hrdinami. jeden hrdina môže byť súčasťou viacero tímov a jeden tím môže mať viac členov. pridaný stĺpec joined_at, na zachytenie času, kedy sa hrdina prihlásil do tímu. Tiež boolean atribút či môže pozývať nových ludí do tímu

## teams
tabuľka, kde sú uložené všetky tímy podľa ich ID. Každý tím má svojho lídra, ktorí riadi ostatních a ako jediný môže rozpustiť celý tím naraz. Ostatní členovia môžu iba odísť z tímu. Každý tím má svoje meno a svoj krátky 5 charakterový tag. tag slúži na lepšiu čitateľnosť v hre. Ak by sme mali tím **Good Geniuses** tak by mohli mať tag **GG**

## team_invites
všetky pozvánky do tímov, ktoré sú odoslané hrdinom. Pre to, aby sa užívateľom nehromadili duplicitné pozvánky ak by dostal pozvánku z tímu XY od dvoch a viac hráčov naraz, tak sa pozvánka odosiela v mene tíma a s ID prvým odosielateľom pozvánky. Pred tým než sa pošle pozvánka, tak sa pozrie systém či už neexistuje pozvánka z tímu XY a ak nie, tak sa spraví nový záznam s ID tímom, ID hrdinu komu ide pozvánka, ID hrdinu ktorý pozval hrdinu a čas kedy bola pozvánka odoslaná. 


# CHAT SECTION
správy medzi hráčmi budú organizované v tzv **roomkach**. toto riešenie má výhodu v tom, že nemusíme deliť správy na individuálne a skupinové, ak by sme chceli pridať nového člena do roomky, tak stačí vytvoriť iba nový záznam v room_participants 

## room_participants
prechodová tabulka, užívateľ môže poslať viac správ