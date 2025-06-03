# Programarea calculatoarelor și limbaje de programare 2 — Tema 2

Soluție realizată de Andrei-Marcel Bădulescu, Universitatea Politehnica București <br>
Dată — 8 mai 2025

### Prefață

<p> Soluția propusă respectă toate restricțiile și precizările privind coding
style-ul, mai exact includerea unor etichete care au un nume sugestiv,
indentarea corectă a codului (unde etichetele sunt așezate la margine, iar
codul este aliniat la un tab) și adăugarea unor comentarii care pot ajuta la
înțelegerea mai rapidă a codului. Acest README are scopul de a explica
succint modul de rezolvare a celor patru cerințe, cât și de a lămuri
anumite decizii luate în decursul implementării soluției prezentate. </p>

### Implementarea soluției
#### Cerința 1
<p> Pentru a rezolva prima cerință, am extras secvențial numerele pentru a
verifica dacă acestea respectă condițiile impuse (numerele trebuie să fie
pare și să nu fie puteri ale lui 2). Numerele care se potriveau acestor filtre
erau mai apoi salvate într-un spațiu de memorie oferit de către funcția
apelantă. </p>

#### Cerința 2
<p> Rezolvarea cerinței 2 s-a bazat pe folosirea unor funcții care ușurau
lucrul cu setul de date (mai exact analizarea și sortarea evenimentelor
oferite). În cadrul primului subpunct, am verificat corectitudinea datelor
fiecărui eveniment respectând precizările din cerință (anul trebuie să
se încadreze între anumite valori, iar zilele și lunile trebuie
să fie valide). </p>

<p> În cadrul celui de-al doilea subpunct, am sortat setul de date folosind
multiple funcții, a căror funcționalitate se aseamănă anumitor metode din
biblioteca standard a limbajului C (de exemplu sortarea unui array, compararea
a două șiruri de caractere sau interschimbarea a două valori). În acest
caz, evenimentele trebuiau sortate după validitatea lor, apoi după dată și în
final după numele acestora.
Apelarea funcțiilor respectă standardul CDECL, devenind astfel
interoperabile cu programe scrise în C. </p>

#### Cerința 3
<p> Cerința 3 presupune transformarea unui șir de octeți (precizarea este
că mereu numărul de octeți este un multiplu al lui 3) într-un string encodat
cu Base64. Am folosit registrele de un octet pentru a ușura lucrul cu biții
individual, întrucât din acestea trebuiau păstrați numai anumiți biți.
Shiftările și operatorii logici au fost utilizați pentru a opera eficient
modificările necesare. Ulterior, valorile rezultate erau folosite pentru a
identifica un caracter în tabela specifică Base64, iar la final acestea
erau salvate într-un spațiu de memorie special alocat de funcția apelantă.</p>

#### Cerința 4
<p> Pentru a rezolva ultima cerință am respectat regulile jocului de Sudoku
referitoare la utilizarea fiecărei cifre.
În cazul verificărilor liniilor și coloanelor, am folosit un pas predefinit
pentru modificarea adresei de la care extrag numărul analizat. Masca de biți
salvată în registrul EBX are rolul de a simplifica verificările efectuate,
întrucât pentru orice cifră există un bit corespunzător acestuia.
În cazul funcției de verificare a pătratelor, am adaptat algoritmul
astfel încât la fiecare 3 căsuțe verificate să modific adresa pentru a
sări pe rândul următor. </p>

<b> Copyright 2025 © Andrei-Marcel Bădulescu. All rights reserved. </b>
