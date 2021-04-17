





<br />





# USER SECTION

## users
najhlavnejšia tabulka v sekcií užívateľov. ukladá nám informácie o koncovom užívateľovi. 
- **realname** - meno,  budeme užívateľa oslovovať mimo hru (email, newsletter)
- **username** - prihlasovacie meno
- **nickname** - prezývka, ktorú si nastavil (pr. steam, username zostáva taký istý, nick nie)
- **password_hash** - heslo nebude ukladané ako plaintext ale ako sha256 hash aby aj "nbusr123" malo ako takú ochranu ( dlžka sha256 hashu - 32byte)
- **email** - dlhy 64 (user) + @ + 255 (domain) = 320 (**podla RFC 5322**)
- **secret** - retazec, ktorý sa pouzíva pri verifikácií emailu
- **verified** - status, ci email bol verifikovany. ked sa vytvori ucet, tak je verified *false* a ked pride email so secretom, ktory user zada, tak sa user uspesne verifikuje.
 Ak je user prihlaseny cez inu sluzbku ako je napriklad facebook alebo google, tak má zaznam v tabulke **external_identity**

## login_logs
v tejto tabuľke sa ukladajú všetky úspešné prihlasovania do účtu. presnejšie sa ukladá užívateľské meno, čas loginu a login data. Login data si môžeme predstaviť ako užitočné informácie pre nás z payloadu -> napr. z akej IP adresy sa user prihlásil a miesto aby logika mohla vyhodnotiť či bude treba verifikovať usera aj iným spôsobom ako heslom. 
**example** steam verifikácia keď sa prihlási z nového zariadenia

## user_relationship
tabulka, kde sú uložené všetky vzťahy užívateľov. V momentálnej situácií to je priateľstvo, ignorovanie "správ" na predídenie spamu a block. Ak by sme chceli expandovať hru a túto tabulku, tak by sme mohli pridať napríklad koľko súbojov prebehlo medzi týmito postavami. Je to asociačná tabuľka medzi dvoma hrdinami. 

## friend_requests
tabulka, ktorá nám ukladá všetky pozvánky priateľstva. Priateľstvo vzniká medzi dvomi hráčmi a nie medzi dvomi hrdinami, čo je výhodnejšie pre samotného koncového užívateľa

<br />
<br />

# TEAM SECTION
do tejto sekcií spadájú tabuľky, ktoré pracujú s tímami. 

## team_members
asociačná tabuľka medzi tímami a hrdinami. jeden hrdina môže byť súčasťou viacero tímov a jeden tím môže mať viac členov. pridaný stĺpec joined_at, na zachytenie času, kedy sa hrdina prihlásil do tímu. Tiež boolean atribút či môže pozývať nových ludí do tímu

## teams
tabuľka, kde sú uložené všetky tímy podľa ich ID. Každý tím má svojho lídra, ktorí riadi ostatních a ako jediný môže rozpustiť celý tím naraz. Ostatní členovia môžu iba odísť z tímu. Každý tím má svoje meno a svoj krátky 5 charakterový tag. tag slúži na lepšiu čitateľnosť v hre. Ak by sme mali tím **Good Geniuses** tak by mohli mať tag **GG**

## team_invites
všetky pozvánky do tímov, ktoré sú odoslané hrdinom. Pre to, aby sa užívateľom nehromadili duplicitné pozvánky ak by dostal pozvánku z tímu XY od dvoch a viac hráčov naraz, tak sa pozvánka odosiela v mene tíma a s ID prvým odosielateľom pozvánky. Pred tým než sa pošle pozvánka, tak sa pozrie systém či už neexistuje pozvánka z tímu XY a ak nie, tak sa spraví nový záznam s ID tímom, ID hrdinu komu ide pozvánka, ID hrdinu ktorý pozval hrdinu a čas kedy bola pozvánka odoslaná. 

<br />
<br />

# CHAT SECTION
správy medzi hráčmi budú organizované v tzv **roomkach**. toto riešenie má výhodu v tom, že nemusíme deliť správy na individuálne a skupinové, ak by sme chceli pridať nového člena do roomky, tak stačí vytvoriť iba nový záznam v room_participants 

## room_participants
prechodová tabulka, užívateľ môže byt vo viacero roomkach a roomky môžu mať viac používateľov. 

## rooms 
tabuľka všetkych chatovacích miestností, každá roomka má svoje meno a typ. Typy môžeme chápať ako zameranie roomky, ktoré si nastavia užívatelia. napríklad typ môže byť **looking for team**, **final boss fight**. 

## messages
tabuľka so všetkými správami. Jedna správa sa skladá z **room_id** (kde bola správa odoslaná), **sender** (kto poslal správu), **created_at** (kedy bola správa vytvorená) a **message_text** ( celý obsah správy). Takýmto uložením správy vieme následne chatovacie roomky upravovať  a lahko auditovať. Text správy vieme pred zobrazením v hernej logike tokenizovať a cenzorovať ak sa tam nachádza nevhodný obsah. V prípade, že užívateľ opakovane porušuje pravidlá a správa sa nevhodne, tak vieme jeho správy aj vymazať. Zobrazenie správ pre jednu roomku si vieme predstaviť ako jednoduchý select všetkých správ kde id roomky je rovnaké. inak povedané, či už si píšeme s jedným kamarátom alebo s celou skupinou, bude nám pridelená roomka.

<br />
<br />


# ACHIEVEMENTS AND STATISTICS


## achievements 
tabulka, ktorá udržiava všetky achievementy v hre. každý achievement má svoje meno, popis a požadované parametre, ktoré musia byť splnené aby hrdina dostal svoj achievement. Achievement sa viaže na hrdinu a nie na účet.

<br />

![alt text](https://github.com/FIIT-DBS/zadanie4-stv10-bencel-z4_krajkovic_palenik/blob/master/images/Achievement.png?raw=true)

<br />

Obrázok 1

## hero_statistics
v tejto tabulke sú uložené všetky akcie hrdinu, či už to je počet zabitých monštier, koľko zlatych mincí minul, koľko bossov zomrelo vďaka nemu a tak ďalej. Je to jedna z primárnych tabuliek aby mohla logika hrdinovy dávať achievementy.

## heroes_achievements
prepájaca tabulky, ktorá prepája achievementy s hrdinami. jeden achievement môže mať viacero hrdinov a jeden hrdina môže mať viac achievementov.

<br />
<br />

# HEROES SECTION
táto sekcia sa bude zaoberať stavebným blokom našej hry a to sú hrdinovia. každý užívateľ má jeden a viac hrdinov alebo postáv, ktoré môže hrať. každý hrdina má svoju vlastnú rasu a svoje vlastné jedno povolanie (class). 


## heroes
hlavná tabuľka, ktorá uchováva všetky hratelné postavy užívateľov.  jeden užívateľ môže mať viacero hrdinov. každý hrdina má svoj basic attack damage, životy, manu a obranné číslo. taktiež peniaze v hre sú rozdelené do dvoch sekcií a to **cash_money** a **bank_money** kde cash money sú peniaze, ktoré má hrdina pri sebe a teda ak ho zabijú tak môže o ne prísť a bank_money sú uložené peniaze v banke o ktoré nemôže prísť. každý hrdina má tiež svoj vlastný level a počet skúsenostných bodov uložených v databáze a **word_level**, čo predstavuje najvyšší level, ktorý hrdina dokázal prejsť. každý hrdina má taktiež svoje povolanie **class_id** a rasu **race_id**

## levels 
tabulka, ktorá nám udržiava levely, počet skúsenostných bodov a nejaké darčeky za dané levely. rozhodli sme sa tieto levely udržiavať v tabuľke aby sme ich mohli meniť ako potrebujeme. 

## classes
povolania hrdinov, každé povolanie má svoje meno a nejaký popis, ktorý bližšie charakterizuje postavu. ďalej každé povolanie je stavané inak a tak dáva zmysel aby aj svoje atribúty sa zvyšovali inak (**XY_per_level**). Predsa len ak by sme si vybrali ako classu barbarského bojovníka tak nám dáva zmysel, že jeho útok a život by sa mal zvyšovať rýchlejšie ako elfský mág. tomu prideluje viacej many na svoje kúzla. každá classa po levelovaní dostane možnosť vybrať si kúzla alebo talenty zo stromu schopností. každá postava má svoje vlastné schopnosti aby sa nestalo, že barbar pošle na nepriatelov pekelnú búrku  
## abilities
táto tabuľka nám slúži na uloženie všetkých abilitiek, ktoré sú v hre. abilitky môžeme chápať ako kúzla (mág) alebo špeciálne útoky (barbar). každá abilitka má nejaký **mana_cost**, pri niektorých classach (*warlock*) to môže byť **health_cost**,  **spell_type** nám hovorí či abilitka berie physical, magical alebo pure damage. pri nastavení **splash_damage** bude abilitka použitá na väčšiu skupinu či už spojencov (*Group Heal*) alebo nepriatelov (*Flames of Incredible Boredom*). Status effect nám naznačuje či tá abilitka má šancu postaviť nepriatela pod efekt ako je (*stun*, *slow*, *boredom*, *silence*,*...*). aby sa hrdina mohol naučiť nejakú schopnosť tak potrebuje **ability_points**, ktoré sú mu pridelené podľa levelu hrdinu. 
## abilities_requirement
aby mohli byť abilitky viazané do stromovej štruktúry a tak som mohol zaviesť požiadavky čo musí hrdina spĺnať aby sa mohol novú abilitku naučiť tak potrebujeme novú tabulku. táto tabulka slúži na uloženie dvoch požiadaviek a to 1. abilitky, ktoré hrdina musí ovládať aby sa mohol naučiť novú schopnosť, a 2. povolanie, ktoré hrdina musí mať. 

## heroes_abilities
asociačná tabulka medzi hrdinami a schopnosťami pre *many to many* vzťah. do tejto tabuľky sa zapisujú všetky naučené schopnosti, ktoré hrdinovia majú.

## races
tabuľka, kde sú udržiavané všetky rasy v našej hre. každá rasa má svoje meno a nejaký ich príbeh prečo sa rozhodli bojovať proti zlému Melishkovi (finálny boss). každá rasa má svoju unikátnu schopnosť (**racial_ability**) - napríklad elfovia vedia byť neviditelný v lese. každá rasa taktiež prichádza so speciálnymi buffmi a začiatočnými atribútmi, ktoré sú pre každú rasu iné.


## perks 
perky sú ako atribúty, ktoré má hrdina a hovoria nám aký je daný hrdina v tej oblasti. ak má hrdina vysoký **persuasion**, tak je prehováranie pre neho hračka, ak má hrdina vysoký **charisma** tak je hrdina vnímaný npc-čkami ako velký idol a urobia mu lepšiu cenu. niektoré perky je možné zvyšovať aj predmetmi. každý hrdina má svoju vlastnú sadu perkov

## skills
tabuľka schopností nám slúži na zapisovanie vedlajších aktivít hrdinu. jedná sa o aktivity ako je napríklad varenie, rybárčenie. pri vysokom varení vie hrdina vytvoriť consumables, ktoré sú viac efektívne ako keď má hrdina menšie levely vo varení. tieto schopnosti sa avšak nedajú vylepšovať pomocou predmetov ani nijako inak, jediná cesta ako si môže hrdina vylepšiť schopnost je tá, že to bude aktívne robiť. 

## unique_mobs_killed
podľa podmienky sa niektoré typy npc môžu zjaviť až po tom ako sa zabije nejaký predchádzajúce monštrum. preto každý hrdina bude mať záznam v tejto tabulke spolu s id npc-čkom aby sme udržiavali aké unikátne monštrá hrdina zabil. je to asociačná tabulka medzi npc postavami a hrdinami. v hernej logike to bude navrhnuté tak, že tieto unikatne moby sa budú spawnovať v oddelenej časti mapy a vstupi iba ten ktorý je hoden (ktory ma poziadavky na zabite moby)

## player_items
tabulka, ktorá slúži ako inventár každého hráča. je to asociačná tabuľka medzi hrdinom a predmetmi. taktiež je potrebné udať či je práve ten item equipnutý alebo nie. herná logika vyrieši, aby predmet nemohol byt nesený na nesprávnom mieste.

<br />
<br />

# QUESTS SECTION
## quests
tabulka, kde sú vedené všetky misie, ktoré existujú v hre. jedna misia - quest - má svoje meno a popis, čo je potrebné aby hrdina spravil aby splnil misiu  a dostal odmenu. na každej mape/lokalite budú npc postavy, ktoré budú dávať tieto misie (**quest_giver_id**), misia zabi finálneho bossa však nebude dostupná ihneď zo začiatku tak preto sú definované požiadavky a to **level_requirement**, **map_requirement**.  každý quest musí nadväzovať čo sa týka príbehu a tak potrebujeme pridať nový požiadavok a to **preceeding_quest_id**, podľa ktorého zoradíme postupnosť questov chronologicky.  každá misia dáva hrdinovi určítú sumu zlatých mincií **gold_reward**, bodov skúseností **xp_reward**

## quest_item_rewards
prepojovacia tabuĺka medzi predmetmi a misiami. niektoré misie môžu ako odmenu dať aj predmeti a tak je potrebné aby aj táto požiadavka bola zahrnutá ako tabuľka kde máme id misií **quest_id** a id predmetu **item_id**. 

## quests_players_relationship
asociačná tabuľka medzi hrdinami a úlohami. jeden hrdina vie mať viacero misií aktívnych a jednu misiu vie mať viacero hrdinov naraz. stĺpec completed nám hovorí, či už danú misiu hrdina splnil.


<br />
<br />

# MAP SECTION
celý koncept sme sa rozhodli rozdrobiť do viacero tabuliek aby sme neboli limitovaný jednou statickou mapou pre každú lokáciu. naše ponímanie sveta je také, že celá hra sa odohráva v nejakom svete, ktorý sa podobá na štýl ťahových RPG hier (*Legend of Grimrock*, *Might and Magic*). Máme teda herný svet (koncept), ktorý sa skladá z rôznych máp ktoré su dostupné pre hráča. Aby sme to opísali lepšie, tak herný svet môže byť podobný tomu na obrázku 2 (rozloženie týchto miest rieši herná logika) a každý tento point kde sa vie dostať hráč bude vyzerať ako nejaký dungeon kde príklad môžeme vidieť na obrázku 3. Teda svet nie je open world ale rozdelený na lokácie.

<br />

![alt text](https://github.com/FIIT-DBS/zadanie4-stv10-bencel-z4_krajkovic_palenik/blob/master/images/diablo_map.jpg?raw=true)

<br />

Obrázok 2

<br />

![alt text](https://github.com/FIIT-DBS/zadanie4-stv10-bencel-z4_krajkovic_palenik/blob/master/images/dungeon_map.jpg?raw=true)

<br />

Obrázok 3

## Map
tu sú udržiavané všetky mapy, ich veľkosť. Meno a popis opisuje hrdinom čo ich čaká v tej lokácií ak sa rozhodnú do nej vstúpiť.

## Objects
aby sme nemali statickú mapu, ktorá sa nemení, tak sme sa rozhodli pridať tabulku s objektami, ktoré každý maju svoje meno a súbor kde sa objekt nachádza ('"bytea"). Dajmä tomu, že hrdinovia sa nachádzajú niekde na centrálnej mape ("HUB") a bližia sa sviatky. Ak pridáme objekt do tabulky objektov tak takto môžeme lahko pridať vianočny stromček na mapu bez toho aby sme museli pretvárať celú mapu.

## map_objects
táto tabuĺka nám slúži ako prepájacia medzi objektami a mapou. zahrna v sebe id mapy, XYZ pozíciu. 

## npc_spawn_rules
táto tabuľka slúži na mapovanie npc postáv na danú mapu. je to miesto, kde sa budú spawnovať npc postavy, ich typ a koľko, herná logika zabezpečí rozostup medzi nimi. predstavme si lokalitu kde v strede opusteneho lesa máme táborák, takéto miesta aj v moderných hrách vyzerajú, že tam bude nejaký nepriatel, takýto príklad môžeme vidieť na obrázku 5. každý záznam má **npc_id**, čas pokial sa oživí po zabití **dead_time**, **XYZ súradnicu**, šanca na dropnutie predmetu po zabití, jeho **xp_reward_factor** a **gold_reward_factor** za zabitie. Tieto dva faktory môžeme chápať tak, že zatial čo Griffin na začiatku bol veĺmi ťažký zabiť tak ku koncu hry bude ľahší a tak by sa malo dostávať za neho menej goldu a xp. Každý takýto spawn má zahrnutý aj level npc, ktoré sú v nom. tento level bude prepočítaný v hernej logike aby niektoré npc boli silné aj keď sa hrdina vylepšuje. 

<br />

![alt text](https://github.com/FIIT-DBS/zadanie4-stv10-bencel-z4_krajkovic_palenik/blob/master/images/npc_spawn.jpg?raw=true)

## players_locations
do tejto tabulky sa priebežne každých n minút zapisuje pozícia všetkých hráčov ak príde k reštartu serveru. Keď sa hráč odhlási z hry, tak sa jeho pozícia tiež uloží ak hráč nie je akurát v súboji.

<br />
<br />


# NPC SECTION
v tejto sekcií si povieme o všetkých tabuľkách, ktoré majú čo to spoločné s nehratelnými postavami
## non_playaber_characters
tabulka, kde sú uložené všetky nehratelné postavy. rozhodli sme sa do tejto tabuľky zahrnúť ako aj nepriateľov, tak aj obyčajných obchodníkov, spojencov, ktorí nie sú hostilny. v hre môžeme zabiť každého. každé npc má svoje meno, hostilitu a unikátny faktor. Ak sa zabije npc, ktoré je unikátne, tak sa zapíše do tabulky **unique_mobs_killed** a toto môže ovplyvniť priebeh hry pre daného hrdinu. Zmení sa príbehová linka pre hrdinu.
Každé npc majú také isté vlastnosti ako hrdina ale hrá za nich počítač, preto majú tiež svoj život, attack, manu a abilitky, ktoré prepája asociačná tabulka **npc_abilities**
Každé npc má svoj range pre drop goldu a xp pointov a svoj vlastný loot_drop, ktorý linkuje tabuľka **loot_drop**

## npc_spells
prepájaca tabulka medzi schopnosťami a npc postavami aby aj nehrateľné postavy mohli používať schopnosti.
## npc_hero_nicknames
keď hráč postupuje levelmi a spĺňa hlavné úlohy tak postupne prechádza míľnikmi, ktoré mu prinášajú tituly. Môže to byť napríklad zabitie bossa, nájdenie špeciálneho predmetu alebo zúčastnenie sa na nejakom evente, kde daný hrdina niečo dokázal. Tituly si hrdina nevie zmeniť v nastavení hry. Predsa len, keby sme dokázali sa prezývať inak, tak by sme to museli povedať každej osobe v našom hernom svete. Chceme preto ponechať roleplay zážitok a preto sa tituly budú viazať k nejakému míľniku. Tituly budú používané nehratelnými postavami ako alterntatíva k užívateľskému menu podľa hostility. 
## loot_drop
tabulka, v ktorej sú zahrnuté informácie o tom, ktoré predmety padajú po zabití nejakej nehratelnej postavy. slúži ako asociačná tabulka a prepája many to many vzťah medzi **npc a items**. každé npc má šancu po jeho zabití poskytnúť hráčovi nejaké predmety. v tejto tabuľke sú aj zapísané akej rarity môže tento predmet byť a  koľko ich padne.

<br />
<br />

# ITEMS SECTION
## items
všeobecná tabulka pre predmety, ktorá spája tabulky **weapons**, **armors**, **accessories** a **consumables**. v tejto tabuľke sa nachádzajú všetky dodatočné informácie o predmete ako je jeho rarita, meno, váha a cena. môžeme to chápať ako všeobecný predmet. ako príklad môžeme uviesť **meč Aerondight**, tento meč bude mať v tabuľke **weapons** definované jeho vlastnosti čo sa týka súboja v tabuľke items jeho meno, predajnú cenu a tak ďalej. Teda jedna zbraň v tabuľke **weapons** môže referuje na jeden predmet a preto tam je kardinalny vztah 1:1. 

## requirements
tabulka kde sú vedené požiadavky čo potrebuje hrdina splnať aby mohol equipnut daný item. požiadavky sú viazane na perky

## item_modifiers
každý hrdina môže meniť svoje predmety, napríklad im môže pridať zvýšenie útočného čísla alebo ho nejako inak modifikovať. v tejto tabulke sa ukladá nejaká modifikácia predmetu, ktorý vlastní hráč.  modifkovať môže v číslach alebo percentách. ako príklad dajmä tomu, že máme meč a hrdina si ho enchantol aby mu zvýšil utočne čislo o 10. do tabulky sa pridá záznam, že **modifies = damage , flat_value = 10, player_item_id  = (id predmetu v inventara hrdinu**. pri enchantovaní môžeme **modifies** nastaviť na **enchanting**

## accessories
tabulka, kde sú uložené všetky doplnky v hre. doplnok je jediný typ predmetu, ktorého hlavný faktor je zvyšovanie **perkov** hrdinu. dajmä tomu, že sme zaklínač a ako doplnok máme medailu, ktorá vibruje keď sú nepriatelia blízko. preto sa hrdinovi zvýši **perception** o zopár bodov.

## consumables
tabulka, kde sú uložené všetky predmeti, ktoré môžu byť zjedeny a tak pridajú nejaký efekt hrdinovy. môžeme to chápať ako lektvary alebo jedlo. každý consumable môže doplnovať zivoty, manu či už jednorázovo alebo počas dlhšej doby. niektore consumables tiež dokážu dať hrdinovy efekt či už pozitívny alebo negatívny. príklad : ak je hrdina spomalený tak vypije lektvar, ktorý odstráni tento debuff.


## weapons
tabulka, kde sa nachádzajú všetky zbrane v hre. zbran má svoje útočné čislo, šancu na kritikálny útok, veľkosť kritikálneho útoku, či sa zbran drží v dvoch rukách alebo nie, typ zbrane a vzdialenosť zbrane (kuša, luk). 

## armor
tabulka, kde sa nachádzajú všetky brnenia (aj štíty) v hre. brnenie má svoje defenzívne číslo, zvýšenie šanci na critical attack a zväčšenie many (čarodejsky klobuk). 

<br />
<br />

# COMBAT SECTION

## npc_fight
ak sa ocitneme v súboji, kde bojujeme naraz spolu s tromi bruxami, tak táto bruxa má každé také isté **id**, lebo je to tá istá nehratelná postva. aby sme vedeli tieto mobky odlíšiť, tak potrebujeme definovať nové unikátne **id**. táto tabuľka slúži na prepojenie viacerých npc so súbojom.

## fights_heroes
asociačná tabulka medzi hrdinami a súbojmi a či hrdina počas súboju zomrel.

## fights
tabuľka, ktorá predstavuje jedne súboj pre hrdinu. jeden fight môže mať viacero rovnakých/rôznych npc, tento vzťah mapuje asociačná tabulka **npc_fight**. fight taktiež môže mať viacero hrdinov, toto je namapované pomocou tabulky **fights_heroes**. jeden fight má uložené aj kedy sa súboj odohral, aká bola xp reward, gold reward a či bol fight vyhraný. môžeme si to pre hrdinu predstaviť ako história súbojov. potrebné pre logovanie 

## combat_logs
hra pracuje na báze kôl kde jedno kolo sa rozdeluje na ťahy. jeden ťah sme my útočník a druhý ťah sme my obrancovia. za jeden ťah môžeme spraviť jeden move, či už zaútočiť alebo vyčarovať nejaké kúzlo. každý súboj musí byť logovaný a tak v tejto tabulke sa nachádzajú všetky ťahy vo všetkých súbojov. každý ťah máme dve strany **attacker** a **defender**. vždy sme z pohladu útočníka a preto sa píše koľko zranenia spôsobil utočnik, koľko života zostalo obrancovy, aké spelly použil útočník a obranca (*obranca sa môže napr štítíť pred kúzlom magickým štítom**). každý záznam v combat logu má uvedený v ktorom ťahu to prebehlo **turn_number** a v ktorom kole to prebehlo **round_number**, taktiež odkazuje na súboj **fight_id**. aby sme predišli nedeterminizmu tak id nehratelných postáv sú nalinkované na tabulkú **npc_fight**, lebo sa môže stať, že bojujeme proti dvom rovnakým nepriatelom (maju rovnake id) a pri auditovani by sme nevedeli na ktorého z nich hrdina zaútočil. 

[![ytb_db_showcase](images/images.png)](https://www.youtube.com/watch?v=dQw4w9WgXcQ)
Ukážka hehe
