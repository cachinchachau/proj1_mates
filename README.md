# proj1_mates

Integrants del grup: Martí Oliveras Planas i Joel Cruz Quevedo


Explicació del Joc:
Aquest joc tracta d'aconseguir tots els power ups necessaris mentre protegeixes les teves mascotes dels enemics i, un cop aconseguits, entrar al portal per poder derrotar el boss final amb l’ajuda d’una de les mascotes i aconseguir el màxim de puntuació. Les decisions més importants que hem pres a l'hora de fer el treball han estat l’ús de la llibreria per fer servir tota mena de botons textos i inputs, ja que tot i que hem hagut d’aprendre com funciona des de zero, un cop l’hem après a fer servir ens ha facilitat la feina de diverses parts de la pràctica. També aquesta decisió comporta al fet que el joc tingui aquest aspecte visual del qual podríem indicar com la seva UI, però com que no feia falta que fos atractiu visualment estem satisfets en com ha quedat. Altres decisions que hem pres serien el sistema de punts el qual hem fet bastant simple per no haver de dedicar-hi massa estona i centrar-nos més en el sistema de vides, ja que se’n demanava un més complex. Finalment, l’última decisió important del nostre joc es la bossfight, la qual hem volgut fer que funcioni de manera que l’ataques com a jugador amb una de les mascotes (la que no té vida) per donar-li més impacte a aquesta en el joc i perquè ens ha semblat una manera original i divertida de fer la batalla final.


Instruccions per jugar:
La primera pantalla que es mostra a l'iniciar el joc mostra dos botons, els quals indiquen si el jugador vol jugar a teclat o a ratolí. Per defecte el joc deixa seleccionat el de ratolí, però el jugador pot escollir amb un clic quin vol, ara bé, si el jugador deixa tots dos botons sense seleccionar, el joc contarà com a seleccionada l'última opció que el jugador hagi tingut en aquest estat. Per jugar amb les tecles cal fer ús de les fletxetes del teclat. L’altra opció a escollir en aquest menú es la quantitat d’enemics, la qual està predeterminada a 13, però es pot configurar escrivint qualsevol altre número. Finalment, s’ha de clicar el botó Start Game per poder canviar de pantalla i començar a jugar.
La puntuació i vida del jugador s’indiquen a la part superior de la pantalla mentre que les vides de la mascota i el boss final tenen forma de barra de vida que es manté sobre d’aquests. Un cop s’acabi el joc a la pantalla quedarà la puntuació final del jugador, un missatge que variarà depenent del resultat de la partida i un botó per tornar a començar a jugar que portarà al jugador directament al menú inicial un cop el cliqui. 


Hem fet servir una llibreria anomenada ControlP5, la qual fa falta descarregar-se per poder jugar al joc i que hem fet servir per fer totes les interaccions amb botons i inputs que conté el joc. Per fer-la servir, cal anar a l'apartat de Sketch --> Importar Biblioteca --> Gestionar Bibliotecas; i buscar el nom de la llibreria i instal·lar-la.


Pel que fa al treball que ha fet cada component del grup, en Martí se n'ha ocupat del menú inicial junt amb l'ús de la llibreria per tots els botons, textos i inputs del joc i el fet de poder escollir el nombre d’enemics i els controls (teclat o ratolí). També, dels enemics completament i del funcionament entre canvis de la majoria d’escenes i el sistema de rejugabilitat. Finalment, s’ha fet càrrec del sistema de puntuació, el redactat del READ ME i part dels comentaris del codi.
D'altra banda, en Joel ha fet el jugador i tot el que està relacionat directament a ell, com les mascotes, els power ups i power downs i les dues maneres de moviment del jugador. També se n’ha fet càrrec del boss final, el protal i els obstacles. Alhora, de tots els sistemes de vida i de comentar part del codi.


Reflexió crítica post projecte:
Com a grup opinem que la pràctica ha anat bé pel que fa a treball en equip, ja que hem estat bastant atents a aquest, decidint dies per fer una trucada per poder-nos ajudar mútuament i avançar amb el projecte i organitzant-nos des del principi de la pràctica tenint dates amb objectius i ben definida l'organització del treball. Pel que fa als aspectes tècnics del treball sí que hem tingut alguna dificultat, com per exemple amb la llibreria sobretot al principi, ja que no hi estàvem acostumats; o amb el lloc on spawnejaven els power ups, però generalment no hem patit cap gran problema.