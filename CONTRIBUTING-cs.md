# Přispívání k void-packages

void-packages jsou páteří distribuce Void Linux. Obsahují všechny definice pro sestavení balíčků ze zdroje.

Tento dokument popisuje, jak můžete jako přispěvatel pomoci s přidáváním balíčků, opravováním chyb a přidáváním funkcí do void-balíčků.

## Požadavky na balíček

Aby mohl být software zahrnut do úložiště Void, musí splňovat alespoň jeden z následujících požadavků.
Výjimky ze seznamu jsou možné a mohou být přijaty, ale jsou extrémně nepravděpodobné.
Pokud si myslíte, že máte výjimku, začněte PR a argumentujte, proč právě tento software,
i když nesplňuje žádné z následujících požadavků, je dobrým kandidátem pro systém Void balíčků.

1. **Systém**: Software by měl být instalován v rámci celého systému, nikoli na uživatele.

1. **Zkompilován**: Software je třeba před použitím zkompilovat, i když se jedná o software, který nepotřebuje celý systém.

1. **Požadován**: Balíček vyžaduje další balíček v úložišti, nebo čekající na zahrnutí.

Zejména je velmi nepravděpodobné, že budou přijata nová témata.
Jednoduché skripty shellu pravděpodobně nebudou přijaty, pokud nebudou poskytovat značnou hodnotu široké uživatelské základně.
Nová písma mohou být přijata, pokud poskytují hodnotu nad rámec estetiky (např. obsahují glyfy pro skript, který chybí v již zabalených písmech).

Rozvětvení prohlížečů, včetně těch založených na Chromiu a Firefoxu, nejsou obecně přijímány.
Takové rozvětvení vyžaduje náročné opravy, údržbu a hodiny výstavby.

Software je třeba používat ve verzi, kterou autoři oznámili jako připravenou k použití širokou veřejností – obvykle se nazývá release.
Beta verze, libovolné revize VCS, šablony využívající tip vývojové větve pořízené v době sestavení a vydání vytvořená správcem balíčku nebudou přijaty.

## Vytvářejte, aktualizujte a upravujte balíčky ve Void svépomocí

Pokud opravdu chcete získat nový balíček nebo aktualizaci balíčku do Void Linuxu, doporučujeme vám přispět sami.

Poskytujeme [komplexní příručku](./Manual-cs.md) o tom, jak vytvářet nové balíčky.
Existuje také [manuál pro xbps-src](./README-cs.md), který se používá k vytváření souborů balíčků ze šablon.

V této příručce předpokládáme, že máte základní znalosti o [git](http://git-scm.org) a také [účet na GitHubu](http://github.com) s [nastaveným SSH]( https://docs.github.com/en/authentication/connecting-to-github-with-ssh).

Měli byste také [nastavit e-mail](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences /setting-your-commit-email-address) na vašem účtu GitHub a v git, aby byly vaše commity správně přidruženy k vašemu účtu GitHub.

Chcete-li začít, ["forkněte"](https://help.github.com/articles/fork-a-repo) git repozitář void-linux `void-packages` na GitHubu a naklonujte jej:

    $ git clone git@github.com:<uživatel>/void-packages.git

To keep your forked repository up to date, setup the `upstream` remote to pull in new changes:
Chcete-li, aby byl váš rozvětvený repozitář aktuální, nastavte `upstream` dálkový ovladač pro stahování nových změn:

    $ git remote add upstream https://github.com/void-linux/void-packages.git
    $ git pull --rebase upstream master

To lze také provést pomocí nástroje `github-cli`:

    $ gh repo fork void-linux/void-packages
    $ gh repo clone <uživatel>/void-packages

Tím se automaticky nastaví dálkový ovladač `upstream`, takže `git pull --rebase upstream master` lze stále používat k udržování vaší větve aktuální.

Důrazně se nedoporučuje používat k provádění změn webový editor GitHub, protože k úpravě a testování změn budete stejně muset naklonovat repozitář.

Důrazně se nedoporučuje používat k přispívání větev `master` vašeho forku.
Může to způsobit mnoho problémů s aktualizací vašeho požadavku na stažení (také nazývaného PR) a otevřením více PR najednou.
Chcete-li vytvořit novou větev:

    $ git checkout master -b <popisný-název>

### Vytvoření nové šablony

K vytvoření nových šablon můžete použít pomocný nástroj `xnew` z balíčku [xtools](https://github.com/leahneukirchen/xtools):

    $ xnew pkgname subpkg1 subpkg2 ...
    (pkgname je název balíčku subpkg je podbalíček)

Šablony musí mít název `void-packages/srcpkgs/<název_balíku>/template`, kde `pkgname` je stejný jako proměnná `pkgname` v šabloně.

Chcete-li získat hlubší informace o obsahu souborů šablon, přečtěte si [manual](./Manual-cs.md) a nezapomeňte procházet existující soubory šablon v adresáři `srcpkgs` tohoto úložiště, kde najdete konkrétní příklady.

### Aktualizace šablony

Aktualizace šablony bude minimálně sestávat ze změny `version` a `checksum`, pokud došlo ke změně upstream verze, a/nebo `revision`, pokud je potřeba změna specifická pro šablonu (např. patch, oprava atd.). .
V závislosti na tom, jaké změny provedl upstream, mohou být nutné další změny šablony.

Kontrolní součet lze automaticky aktualizovat pomocí pomocníka `xgensum` z balíčku [xtools](https://github.com/leahneukirchen/xtools):

    $ xgensum -i <název balíku>

### Odeslání vašich změn

Po provedení změn zkontrolujte, zda se balíček úspěšně sestavil. Z adresáře nejvyšší úrovně vaší místní kopie úložiště `void-packages` spusťte:

    $ ./xbps-src pkg <název balíku>

Váš balíček se musí úspěšně sestavit alespoň pro x86, ale doporučujeme také vyzkoušet cross-build pro armv6l*, např.:

    $ ./xbps-src -a armv6l pkg <název balíku>

Při sestavování pro `x86_64*` nebo `i686` se důrazně doporučuje sestavení s příznakem `-Q` nebo s `XBPS_CHECK_PKGS=yes` nastaveným v `etc/conf` (pro spuštění fáze kontroly).
Také nové balíčky a aktualizace nebudou přijaty, pokud nebyly otestovány instalací a spuštěním balíčku.

Až dokončíte práci na souboru šablony, zkontrolujte jej pomocí pomocníka `xlint` z balíčku [xtools](https://github.com/leahneukirchen/xtools):

    $ xlint <název šablony>

Pokud `xlint` hlásí nějaké problémy, vyřešte je před odevzdáním "commit".

Jakmile provedete a ověříte změny v šabloně balíčku a/nebo jiných souborech, proveďte jeden commit na balíček (včetně všech změn v jeho dílčích balíčcích). Každá commit zpráva by měla mít jeden z následujících formátů:

* pro nové balíčky použijte `New Package: <pkgname>-<verze>` ([příklad](https://github.com/void-linux/void-packages/commit/8ed8d41c40bf6a82cf006c7e207e05942c15bff8)).

* pro aktualizace balíčku použijte `<název balíku>: update to <verze>.` ([příklad](https://github.com/void-linux/void-packages/commit/c92203f1d6f33026ae89f3e4c1012fb6450bbac1)).

* pro úpravy šablony bez změny verze použijte `<název balíčku>: <důvod>` ([příklad](https://github.com/void-linux/void-packages/commit/ff39c912d412717d17232de9564f659b037e95b5)).

* pro odstranění balíčku použijte `<název balíku>: remove package` a do těla potvrzení uveďte důvod odstranění ([příklad](https://github.com/void-linux/void-packages/commit/4322f923bdf5d4e0eb36738d4f4717d72d0a0ca4)).

* pro změny jakéhokoli jiného souboru použijte `<název souboru>: <důvod>` ([příklad](https://github.com/void-linux/void-packages/commit/e00bea014c36a70d60acfa1758514b0c7cb0627d),
  [příklad](https://github.com/void-linux/void-packages/commit/93bf159ce10d8e474da5296e5bc98350d00c6c82), [příklad](https://github.com/void-linux/void/6b38c529commi9996b38c599commi99 [příklad](https://github.com/void-linux/void-packages/commit/e52317e939d41090562cf8f8131a68772245bdde))

Pokud chcete své změny popsat podrobněji, vysvětlete je v těle commitu (oddělené od prvního řádku prázdným řádkem) ([příklad](https://github.com/void-linux/void-packages/commit/ f1c45a502086ba1952f23ace9084a870ce437bc6)).

`xbump`, dostupný v balíčku [xtools](https://github.com/leahneukirchen/xtools), lze použít k odevzdání nového nebo aktualizovaného balíčku:

    $ xbump <pkgname>  <git commit options>

`xrevbump`, který je také dostupný v balíčku [xtools](https://github.com/leahneukirchen/xtools), lze použít k provedení úpravy šablony pro balíček:

    $ xrevbump '<zpráva>' <názvy balíčků...>

`xbump` a `xrevbump` použijí `git commit` k potvrzení změn s příslušnou commit zprávou. Pro jemnější kontrolu nad odevzdáním lze konkrétní možnosti předat příkazu `git commit` tak, že je přidáte za název balíčku.

### Spuštění požadavku na natažení

Jakmile balíček úspěšně sestavíte, můžete [vytvořit žádost o natažení](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request ). Žádosti o natažení jsou také známé jako PR.

Většina požadavků na natažení by měla obsahovat pouze jeden balíček a závislosti, které ještě nejsou součástí void-packages.

Pokud provádíte aktualizace balíčků obsahujících soname bump, musíte také aktualizovat `common/shlibs` a revbumpovat všechny balíčky, které jsou závislé.
Pro každý revbump balíčku by měl existovat commit a tyto commity by měly být součástí stejného požadavku na natažení.

Když ve svém požadavku na natažení provedete změny, *nezavírejte a znovu neotevírejte požadavek na natažení*. Místo toho stačí [násilně git push](#review), přepsat všechny staré commity. Zavírání a otevírání vašich žádostí o natažení opakovaně spamuje správce Void.

#### Průběžná integrace

Žádosti o natažení jsou automaticky odesílány k testování kontinuální integrací (CI), aby se zajistilo, že se balíčky sestaví a projdou jejich testy (na nativních sestaveních) na různých kombinacích knihovny C a architekturách.
Balíčky, které trvají déle než 120 minut nebo potřebují více než 14G úložiště k dokončení svého sestavení (například Firefox nebo jádro Linuxu), selžou v CI a měly by obsahovat `[ci skip]` v názvu nebo textu PR (pole komentáře při otevírání PR), aby se zabránilo plýtvání časem CI builderu.
Použijte svůj nejlepší úsudek o době výstavby na základě vašich místních zkušeností se stavbou. Pokud při odesílání PR přeskočíte CI, sestavte a křížově sestavujte pro různé architektury lokálně, s glibc i musl, a poznamenejte si své místní výsledky v komentářích k PR.
Ujistěte se, že pokrýváte 64bitové a 32bitové architektury.

Pokud si všimnete selhání v CI, ke kterému nedošlo lokálně, je to pravděpodobně proto, že jste lokálně nespustili testy.
K tomu použijte `./xbps-src -Q pkg <balíček>`.
Některé testy nebudou fungovat v prostředí CI nebo vůbec a jejich šablony by měly tyto informace zakódovat pomocí proměnné `make_check`.

Průběžná integrace také zkontroluje, zda změněné šablony
dodržují naše pokyny. V tuto chvíli ne všechny balíčky splňují pravidla, takže pokud balíček aktualizujete, může hlásit chyby o místech, kterých jste se nedotkli. Neváhejte také opravit tyto chyby.

#### Posouzení

Je možné (a běžné), že žádost o natažení bude obsahovat chyby nebo recenzenti požádají o další vylepšení.
Recenzenti vaši žádost o natažení okomentují a upozorní na to, které změny jsou nutné, než bude možné žádost o natažení sloučit.

Většina PR bude mít jediné potvrzení, jak je vidět [výše](#committing-your-changes), takže pokud potřebujete provést změny v commitu a již máte otevřený požadavek na natažení, můžete použít následující příkazy:

    $ git add <soubor>
    $ git commit --amend
    $ git push -f


Výkonnější způsob úpravy commitů než pomocí `git commit --amend` je s [git-rebase](https://git-scm.com/docs/git-rebase#_interactive_mode), který vám umožňuje připojit se, změnit pořadí , změnit popis minulých commitů a další.

Případně, pokud se vyskytnou problémy s vaší historií git, můžete vytvořit další větev a poslat ji do stávajícího PR:

    $ git checkout master -b <pokus2>
    $ # provést změny znovu
    $ git push -f <fork> <pokus2>:<branch-of-pr>

#### Zavření požadavku na natažení


Až provedete všechny požadované změny, recenzenti vaši žádost sloučí.

Pokud se žádost o natažení na několik dní stane neaktivní, recenzenti vás mohou nebo nemusí varovat, když se chystají ji zavřít.
Pokud zůstane neaktivní dále, bude uzavřena.

Při revizi šablon se prosím zdržte dočasného uzavření požadavku na natažení. Místo toho zanechte komentář k PR s popisem toho, co ještě potřebuje zapracovat, [označte to jako koncept](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/changing-the-stage-of-a-pull-request#converting-a-pull-request-to-a-draft), nebo přidejte „[WIP]“ do PR titulu. Požadavek na natažení zavřete, pouze pokud jste si jisti, že nechcete, aby byly zahrnuty vaše změny.

#### Publikování balíčku

Jakmile recenzenti sloučí požadavek na natažení, automaticky se spustí náš [sestavovací server] (http://build.voidlinux.org) a sestaví
všechny balíčky v požadavku na natažení pro všechny podporované platformy. Po dokončení jsou balíčky dostupné všem uživatelům Void Linuxu.

## Testování Požadavků na natažení

I když je odpovědností tvůrce PR otestovat změny před odesláním, jedna osoba nemůže otestovat všechny možnosti konfigurace, případy použití, hardware atd.
Testování nových balíčků a aktualizací je vždy užitečné a je to skvělý způsob, jak začít s přispíváním.
Nejprve [klonujte úložiště](https://github.com/void-linux/void-packages#quick-start), pokud jste tak ještě neudělali.
Poté zkontrolujte požadavek na natažení, buď pomocí `github-cli`

    $ gh pr checkout <číslo>

Nebo pomocí `git`:

Pokud je vaše místní úložiště void-packages klonováno z vašeho forku, možná budete muset nejprve přidat hlavní úložiště jako vzdálené:

    $ git remote add upstream https://github.com/void-linux/void-packages.git

Poté stáhněte a vyzkoušejte PR (nahraďte `<remote>` buď `origin` nebo `upstream`):

    $ git fetch <remote> pull/<číslo>/head:<název-větve>
    $ git checkout <název-větve>

Poté [sestavte a nainstalujte](https://github.com/void-linux/void-packages#building-packages) balíček a otestujte jeho funkčnost.
