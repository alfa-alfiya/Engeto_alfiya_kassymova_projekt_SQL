Engeto_course_2024_project

Ahoj Alfiyo, lektor Michaela Desová ti posílá hodnocení tvého projektu  SQL projekt.

Něco tomu chybělo, proto ti projekt vracíme k vylepšení. Víme, že to dokážeš ještě lépe! Lektor ti navíc sepsal i podrobnější komentář a rady, jak kód vylepšit.

Hodnocení od lektora: ZAMÍTNUTO

Co se mi líbilo: Scripty jsou dobře formátované, používáš kapitálek pro vyhrazená slova, odsazování.

Nápočet tabulek primary a secondary je velmi dobrý - jednoduchý a funkční bez zbytečných komplikací.

Co by jsi měl/a zlepšit: Chci apelovat na používání LEFT JOIN namísto RIGHT JOIN. ZA celou praxi jsem se s tím setkala jen jednou a jak říká můj kolega je to pro zmatení nepřítele. Asi podvědomě tím že čteme a píšeme zleva doprava je pro nás LEFT JOIN přirizenější.

Prosím pokud dáváš finální script odstraň zakomentavané části. Upřímně se ve scriptech pro otázky zrtácím kolik je tam komentářů.

SELECT * se používá pro prohlížení dat. V praxi se při tvorbě tabulek vždy vypisují všechny sloupce. S * je script velmi špatně čitelný . Musíš si dohledávat jaké sloupce v tabulce vlastně jsou.

U otázky 2 se mělo počítat s celorepublikovou průměrnou mzdou . Výsledkem tedy měly být pouze 4 čísla. Zvolila sis složitější variantu na vyhodnocování, ale v tomto případě ji uznávám.

U otázky číslo 4 se má opět použít celorepubliková průměrná mzda a celorepubliková průměrná cena potravin. Tak jak jsi výpočet koncipoval ty nedává smysl.

Upřímně nechápu proč jsi u otázky číslo 5 vybíráš tyto roky WHERE year IN ('2017', '2016', '2015', '2014', '2007', '2006'). Chybí mi jakékoliv zdůvodnění. Pokud si chceš data takto filtrovat prosím o doplnění komentáře proč.

Pokud používáš agregační funkce SUM, COUNT, AVG je nutné použít v SELECTU použít všechny sloupce ze SELECTU mIimo agregaci. Tato databáze ti spuštění scriptu umožní ale většina databázi by script ani nespustila.

Závěr: Chci pochválit scripty pro tabulky primary a secondary a otázku číslo 1. Scripty jsou velmi dobré. Od otázky 2 mám ale pocit že se trochu ztrácíš v zadání.

Otázku číslo 2 jsi počítal netradičně ale uznávám že řešení tak jak jsi ho dělal je správné a správně odůvodněné v odpovědi.

U otázky 4 a 5 ale musím požádat o přepracování. U 4 použít průměrné celorepublikové mzdy a průměrnou cenu za všechny potraviny (ne podle skupin). U otázky číslo 5 prosím o vysvětlení proč filtruješ roky .

U všech kodu odstraň zakomentované kusy kodu (ne odpovědi na otázky ale zadání), ale části kodu které nepoužíváš. Kod je s tolika komentovanými částmi velmi nepřehledný a velmi špatně se mi v něm orientuje.

Pokud budeš mít nějaké otázky neváhej se na mě obrátit na discordu (misadesova_31967) Míša Desová

Po přepracování můžeš projekt odevzdat znovu, lektor se na něj opět podívá. Pokud si nevíš s něčím rady, kontaktuj lektora na Discordu přes soukromé zprávy. Jak na to? Mrkni na  náš návod. Lektora najdeš na Discordu pod jménem  misadesova_31967. Preferuješ e-mailovou komunikaci? Ozvi se mu na  desovamichaela@gmail.com.


Ať se ti daří! ENGETO
