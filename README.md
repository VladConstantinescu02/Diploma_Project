# diploma_prj

Eng

Dishify - am app for meal suggestions

The main goal of this app is to allow users to enter the current state of their fridge or pantry, using that set of ingredients and other parameters they may choose (such as allergens, diet requirements or other ingredients they may not enjoy), to receive suggestions on meals that meet their requirements.
A secondary goal of this program is to reduce help in combating food waste, through the meal suggestion function. Lastly, a tertiary goal of this app is to contribute to the improvement of the user’s financial situation, by not only encouraging home cooking and the use of already bought ingredients, but also by reducing the need for take-out.

● In order to access the app and to let each user have a unique experience, each user must create an account requiring to add a profile photo, a email address, a username and a password, this is ensured through the Firebase Authentication service

● The fridge section - one of the key features of the app, the user is prompted to add a virtual instance of the ingredients that are available in his fridge. Each ingredient must have an approximate quantity. An ingredient’s quantity is broken down into two main parts: a unit of measurement (e.g., g, ml, l, etc.) and number representing the value of the ingredient. Once a food item is added, its calories per 100g will be displayed. All these functionalities are handled through the Spoonacular API, one of its key features being the ability to search for specific ingredients.

● Meals section - when the user is set on creating a new meal, they are prompted to search the meal type (e.g breakfast, lunch, dinner), a designer minimum and maximum amount of calories, a type of diet they wish to enjoy (e.g., keto, paleo, etc.), an allergen (e.g, peanuts, etc.) and a ingredient they wish to avoid. They may also opt to have some, none or all the ingredients from the fridge taken into consideration when searching for their meal. Once all these parameters are met, the user may simply generate a meal, and have it displayed in a card in their meals page, leaving them the opportunity to either delete it, or have it saved for a later date. This functionality allows the user a greater freedom when choosing how and when to prepare their desired meal. This feature is also one of the main features of the Spoonacular API, working in tandem with the ingredient search feature provided by the API.

● Home section - acts as a nice landing page for when the user is logged in, or already logged in. Its main use is to have some quick action buttons, to let the user quickly navigate to the fridge, meal or profile screen

● Profile screen - lets the user have a nice and cozy amount of customizability, by letting them reset their password, change their username and profile photo.


Ro

Dishify – o aplicație pentru sugestii de mese

Scopul principal al acestei aplicații este de a permite utilizatorilor să introducă starea actuală a frigiderului sau cămării lor, iar pe baza acestui set de ingrediente și a altor  opțiuni alese (precum alergeni, cerințe dietetice sau ingrediente pe care vor să le evitp), să primească sugestii de mese care să le îndeplinească cerințele.
Un scop secundar al aplicației este de a contribui la combaterea risipei alimentare, prin funcția de sugestii de mese. În cele din urmă, un al treilea scop al aplicației este acela de a contribui la îmbunătățirea situației financiare a utilizatorului, încurajând gătitul acasă și folosirea ingredientelor deja cumpărate, reducând astfel nevoia de a comanda mâncare.

● Secțiunea de autentificare – pentru a accesa aplicația și a oferi fiecărui utilizator o experiență unică, fiecare trebuie să-și creeze un cont care necesită adăugarea unei fotografii de profil, a unei adrese de e-mail, a unui nume de utilizator și a unei parole. Acest lucru este gestionat prin serviciul Firebase Authentication.

● Secțiunea Frigiderului – una dintre funcționalitățile cheie ale aplicației; utilizatorul este invitat să adauge un echivalent virtual al ingredientelor disponibile în frigiderul său. Fiecare ingredient trebuie să aibă o cantitate aproximativă. Cantitatea unui ingredient este împărțită în două părți principale: o unitate de măsură (ex: g, ml, l etc.) și o valoare numerică. Odată adăugat alimentul, vor fi afișate caloriile sale la 100g. Toate aceste funcționalități sunt gestionate prin API-ul Spoonacular, una dintre funcțiile sale principale fiind capacitatea de a căuta ingrediente specifice.

● Secțiunea Mese – atunci când utilizatorul dorește să creeze o nouă masă, este invitat să selecteze tipul mesei (ex: mic dejun, prânz, cină), o valoare minimă și maximă de calorii, un tip de dietă pe care dorește să o urmeze (ex: keto, paleo etc.), un alergen (ex: arahide) și un ingredient pe care dorește să îl evite. De asemenea, poate opta pentru luarea în considerare a unora, a niciunuia sau a tuturor ingredientelor din frigider în căutarea mesei. După completarea tuturor acestor parametri, utilizatorul poate genera o masă, care va fi afișată sub forma unui card în pagina de mese, oferindu-i opțiunea de a o șterge sau salva pentru o dată ulterioară. Această funcționalitate oferă utilizatorului o mai mare libertate în alegerea modului și momentului în care să-și pregătească masa dorită. Această caracteristică este una dintre funcțiile principale ale API-ului Spoonacular, lucrând împreună cu funcția de căutare a ingredientelor oferită de același API.

● Secțiunea Acasă – acționează ca o pagină de start prietenoasă atunci când utilizatorul este logat sau se loghează. Scopul principal al acesteia este de a oferi butoane de acțiune rapidă, pentru a permite utilizatorului să navigheze cu ușurință către ecranele Frigider, Mese sau Profil.

● Ecranul de Profil – permite utilizatorului un grad plăcut de personalizare, oferindu-i opțiunea de a-și reseta parola, de a-și schimba numele de utilizator și fotografia de profil.


To compile the app:

The Flutter/ Dart SDK must be installed: https://youtu.be/mMeQhLGD-og?si=1KLDd11aM0e6LSmS
After the download and installation process, the set of command necessary for the compilation of the app are:

flutter pub get
flutter run

To connect to a Firebase project with a similar structure:

![image](https://github.com/user-attachments/assets/6479e28a-9685-47dd-b62e-c9363d2d5937)

Please find: https://firebase.google.com/docs/flutter/setup

Of note is that the app was developed to run using the Java 17 SDk, for compiling the app on Android devices, and for consistend performance of the Firebase SDK.

Alternetively, it can be downloaded here:

https://drive.google.com/drive/folders/1_piPK5F1fIQSWHU4Z7TerGDhL29hIGW7?usp=sharing

GitHub link:

https://github.com/VladConstantinescu02/Diploma_Project
