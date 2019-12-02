# Autóbérlő alkalmazás iOS admin kliens dokumentácó

### Témalabor(BMEVIAUAL00) - Csapat: Pénzfeldobás
### Krausz Dániel - JPYEL5


## Leírás

A feladat egy autó bérlő rendszerhez tartozó kliens megvalósítása volt, amelyben a rendszer adminisztrátorós feladatait képes ellátni. Ezek közé tartozik a regisztrált felhasználók listázása, elfogadása, beérkező bérlések és az autók kezelés, az egyes autók pozíciójának lekérdezése.
Előbbiek megvalósításához szükséges volt a csapatfeladat részeként megvalósított backend szolgáltatásokkal való együttműködés is. Az alkalmazás iOS 13 platformra készült el, Swift 5.1 nyelven írdóva.

## Architektúra

Az architektúra megvalósításához MVC szerkezetet alkalmaztam. A modellek elsősorban a fő megjelenített adattípusokat tartalmazzak strukturák formájában, ilyen a felhasználó (*Customer*), bérlés (*Rent*), autó (*Car*), állomások (*Station*). Itt említendő még a hálózati kezelés amit elsősorban a *CarRentService* valósít még, a külső Moya könyvtárra épülve.

A View-hoz tartozó részek főleg a Storyboard-on találhatóak és az Xcode vizuális szerkersztőjével kerültek létrehozásra.

A ViewController osztályokban elsősorban a nézetekhez tartozó egyes lista, illetve részletes nézetek feltöltése történik adatokkal, valamint a gombok, felhasználói interakciók kezelése is.

## Felhasznált külső könyvtárak
Az alkalmazás készítése során igyekeztem a legtöbb dolgot magamtól megírni, így csak néhány külső könyvtár került felhasználásra. Ezeket a Swift build rendszerbe integrált [Swift Package Manager](https://swift.org/package-manager/)-rel importáltam be.

- *Moya* [<https://github.com/Moya/Moya>]: A Moya könyvtár segítségével lett a hálózatkezelés megvalósítva. Itt az egyes API endpointok egy-egy enum esetként lettek megvalósítva, ami által az API-k meghívása viszonylag egyszerűvé vált, nem kellett külön a hibákat, HTTP headereket kezelni. A Moya használata sokat segítette a kérések megvalósítását, illetve jelentős mennyiségű kódot is megspórolt.

- *KeychainAccess* [<https://github.com/kishikawakatsumi/KeychainAccess>]: A KeychainAcces könyvtár az iOS Keychain-hez való hozzáférést teszi egyszerűbbé. Erre a felhasználóhoz tartozó hitelesítő adatok tárolása miatt volt szükség, amelyek bejelentkezéskor mentődnek el, ezáltal a felhasználónak nem szükséges az alkalmazás minden megnyitásakor újra bejelentkeznie. A hitelesítő adatok a 'Logout' funkcióval törölhetők az eszközről.

## Új ismeretek, felmerült problémák és megoldásuk
Mivel korábban nem foglalkoztam iOS fejlesztéssel, csak felhasználóként használtam a rendszert, így eleinte elég sok problémába ütköztem, amiket utánajárással, valamint néha a csapattársaim segítségével sikerült végül megoldani.

Legtöbb problémát a UI elemek wireframekhez való igazítása okozta, ez viszonylag sok időt is vett igénybe, így sokszor a funkcionalitás megvalósítását helyeztem előbbre, a felhasználói elemek helyett.

## Összefoglalás
Összességében úgy érzem, hogy nagyon sokat tanultam mind az alkalmazás fejlesztés, mind a csapatmunka terén, azonban úgy érzem, hogy az alkalmazáson sokat lehetne még javítani, új funkciókat hozzáaadni további idő befektetésével.

A félév során tanultak alapján egyes részeket másképpen, hatékonyabban valósítanék már meg, így szükséges lenne a kód egy kisebb mértékű refaktorálása. Illetve a wireframe-ből végleges designra való alakítás is megvalósításra váró feladat még.
