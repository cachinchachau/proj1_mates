
//ControlP5 input
//ControlP5 cp5;
//boolean startPressed;



////Set-Up
//void setup()
//{
//  //pantalla
//  size (800, 800);
  
//  //asegurarnos de que cuadrados/rectangulos aparecen al centro de las coordenadas
//  rectMode(CENTER);
  
//  actualScene = Scene.MENU;
  
//  //pj stats
//  pjSize = width/20;
//  pjSpeed = 7;
  
//  //pnjs stats
//  pnjS[0] = 5;
//  //0 porque espera a ser recogido
//  pnjS[1] = 0;
//  dist[0] = 125;
//  dist[1] = 75;
//  hp[0] = 5;
//  hp[0] = 5;
  
//  //pnjs spawnpoint
//  pnjX[0] = width/2;
//  pnjY[1] = 0;
//  pnjX[1] = random(750);
//  pnjY[1] = random(750);
  
//  //powerUps spawn
//  powsSpawned = false;
  
//  for (int i = 0; i < 3; i++)
//  {
//    powUpX[i] = 10000;
//    powUpY[i] = 10000;
//  }
//  //powerDowns spawnpoint
//  for (int i = 0; i < 3; i++)
//  {
//    powDownX[i] = random(50, 750);
//    powDownY[i] = random(50, 750);
//  }
  
//  //powerUps get = false
//  for (int i = 0; i < 3; i++)
//  {
//    powUpGet[i] = false;
//  }
//  //powerDowns get = false
//  for (int i = 0; i < 3; i++)
//  {
//    powDownGet[i] = false;
//  }
  
//  startPressed = false;

//  input(); //funcio inputs
//}




////Draw
//void draw()
//{
  
//  background(0, 0, 0);
  
//  switch (actualScene)
//  {
//    case MENU:
//      n = int(cp5.get(Textfield.class,"Introdueix el Nombre d'Enemics").getText());
      
//      if (startPressed)
//      {
//        inputsOff();
//        menuScene();
//      }
//      break;
//    case GAME:
//       pjX = mouseX;
//  pjY = mouseY;
  
//  //check if pnj2 picked
//  if (checkDist(pjX, pjY, pnjX[1], pnjY[1]) < 50) //check sense .mag
//  {
//    //ahora te sigue
//    pnjS[1] = 3;
//    powers = true;
    
//    if (!powsSpawned)
//    {
      
//      //spawnPows
//      for (int i = 0; i < 3; i++)
//      {
//        boolean canSpawn = false;
        
//        while(!canSpawn)// con este bucle nos aseguramos de que no spawneen encima del jugador, por lo tanto coleccionandolos automaticamente.
//        {
//          powUpX[i] = random(50, 750);
//          powUpY[i] = random(50, 750);
          
//          if (checkDist(pjX, pjY, powUpX[i], powUpY[i]) > width/20)
//          {
//            canSpawn = true;
//          }
          
//        }
        
//      }
//      //powerDowns spawnpoint
//      for (int i = 0; i < 3; i++)
//      {
//        boolean canSpawn = false;
        
//        while(!canSpawn)
//        {
//          powDownX[i] = random(50, 750);
//          powDownY[i] = random(50, 750);
          
//          if (checkDist(pjX, pjY, powDownX[i], powDownY[i]) > width/20)
//          {
//            canSpawn = true;
//          }
          
//        }
        
//      }
//      powsSpawned = true;
//    }
    
//  }
  
//  //CALC
  
  
//  //pnjs calc
//  for (int i = 0; i < 2; i++)
//  {
//    if (checkDist(pjX, pjY, pnjX[i], pnjY[i]) > dist[i])
//    {
//      pnjV[i] = new PVector (pjX - pnjX[i], pjY - pnjY[i]);
//      pnjV[i] = pnjV[i].normalize().setMag(pnjS[i]); //fer calcs sense .normalize y .setMag
//      pnjX[i] += pnjV[i].x;
//      pnjY[i] += pnjV[i].y;
//    }
//  }
  
//  // p(alfa) = PNJ + alfa * PJ --> p(alfa) = (1-alfa) * PNJ + alfa * PJ
//  for(int i = 0; i < m/2; i++)
//  {
//    if (checkDist(pjX,pjY,x_pnj[i],y_pnj[i]) >= width/2)
//    {
//      x_pnj[i] = (1.0 - (-alfa[i])) * x_pnj[i] + (-alfa[i]) * pjX;
//      y_pnj[i] = (1.0 - (-alfa[i])) * y_pnj[i] + (-alfa[i]) * pjY; 
//    }
//    else
//    {
//      x_pnj[i] = (1.0 - alfa[i]) * x_pnj[i] + alfa[i] * pjX;
//      y_pnj[i] = (1.0 - alfa[i]) * y_pnj[i] + alfa[i] * pjY; 
//    }
//  }
//    for(int i = m/2; i < m/4 + m/2; i++)
//  {
//    x_pnj[i] = (1.0 - alfa[i]) * x_pnj[i] + alfa[i] * pnjX[0];
//    y_pnj[i] = (1.0 - alfa[i]) * y_pnj[i] + alfa[i] * pnjY[0]; 
//  }
//    for(int i = m/2+m/4; i < m; i++)
//  {
//    x_pnj[i] = (1.0 - alfa[i]) * x_pnj[i] + alfa[i] * pnjX[1];
//    y_pnj[i] = (1.0 - alfa[i]) * y_pnj[i] + alfa[i] * pnjY[1]; 
//  }
  
//  //RENDERS
  
//  //portal
//  if (powUpGot == 3)// miramos la condicion para crear el portal
//  {
//    fill(255, 0, 255);
//    ellipse(width/2, height/2, width/3, width/3);
//  }
  
//  //pj
//  fill(0, 255, 0);
//  ellipse(pjX, pjY, pjSize, pjSize);
  
//  //pnj1
//  fill(0, 174, 230);
//  ellipse(pnjX[0], pnjY[0], width/20, height/20);
//  fill(174, 0, 174);
  
//  //pnj2
//  ellipse(pnjX[1], pnjY[1], width/20, height/20);
  
//  //powerups
//  fill(255, 255, 255);
//  for (int i = 0; i < 3 && powers ; i++)
//  {
//    if (!powUpGet[i])
//    {
//      square(powUpX[i], powUpY[i], 20);
//    }
//  }
  
//  //powerdowns
//  fill(255);
//  for (int i = 0; i < 3 && powers ; i++)
//  {
//    if (!powDownGet[i])
//    {
//      square(powDownX[i], powDownY[i], 20);
//    }
//  }

// //Draw els enemics
// if (m > 0)
// {
//   for (int i = 0; i < m; i++)
//   {
//     fill(255,0,0);
//     ellipse(x_pnj[i],y_pnj[i], width/25, height/25);
//   }
// }
 
//  EnemySpawner();
//      break;
//    case BOSS:
      
//      break;
//    case GAMEOVER:
      
//      break;
      
//  }
  
  
//}


////EVENTOS
//void EnemySpawner()
//{
//  if (second() >= counterNSpawning+2 && m < n)
//  {
//      m++;
//      counterNSpawning = second();
//  }
//}



//void mouseMoved()
//{
  
//  //COLLISIONES
  
//  //println(checkDist(pjX, pjY, powUpX[0], powUpY[0]));
//  //println(pjX, pjY);
//  //println(powUpX[0], powUpY[0]);
  
//  //powerUps
//  for (int i = 0; i < 3; i++)
//  {
//    if (!powUpGet[i])
//    {
//      if (checkDist(pjX, pjY, powUpX[i], powUpY[i]) < pjSize)
//      {
//        powUpGet[i] = true;
//         powUpGot++;
        
//        switch(i)
//        {
//          case 0:
//            pjSize *= 1.5;
//            break;
//          case 1:
//            pnjS[0] = 7;
//            pnjS[1] = 5;
//            break;
//          case 2:
//            pjSpeed = 10;
//            break;
//        }
//      }
//    }
//  }
  
//  //powerDowns
//  for (int i = 0; i < 3; i++)
//  {
//    if (!powDownGet[i])
//    {
//      if (checkDist(pjX, pjY, powDownX[i], powDownY[i]) < pjSize/1.25) //dividimos entre 1,25 ya que sino lo hacemos al detectar al jugador cuando ha tenido su tama;o augmentado no queda bien
//      {
//        powDownGet[i] = true;
//      }
//    }
//  }
  
//}

//void keyPressed()
//{
  
//  switch(keyCode)
//  {
//    case UP:
//      pjDir[1] = -1;
//      break;
//    case DOWN:
//      pjDir[1] = 1;
//      break;
//    case LEFT:
//      pjDir[0] = -1;
//      break;
//    case RIGHT:
//      pjDir[0] = 1;
//      break;
//    default:
//      pjDir[0] = 0;
//      pjDir[1] = 0;
    
//  }
  
//  println(pjDir[0], pjDir[1]);

//}

//float checkDist(float x1, float y1, float x2, float y2)
//{
//  return (new PVector (x1 - x2, y1 - y2).mag()); 
//}



//void input()
//{
//  PFont font = createFont("arial",20); //Variable que indica la font que volem fer servir(Arial, mida 20) pels components d'aquesta llibreria
//  cp5 = new ControlP5(this);
  
//  //Butons per escollir el tipu de controls que es faran servir per la partida
//  cp5.addRadioButton("controlType") //Creació d'element per escollir el tipu de controls pel joc
//   .setFont(font) //Seteja la font que hem posat en variable anteriorment perque aquest component la faci servir(Arial, 20)
//   .setPosition(200,200) //posicio dins la pantalla del component
//   .setItemWidth(50) //Width dels butons que es defineixen seguidament
//   .setItemHeight(40) //Height dels butons que es defineixen seguidament
//   .addItem("Ratolí", 0) //Creador d'un botó "Ratolí" que definim com a 0
//   .addItem("Teclat", 1) //Creador d'un botó "Teclat" que definim com a 1 (1 i 0 funcionen com un true / false.)
//   .activate(0) //Element que seteja des del principi una de les dos opcions(en aquest cas la del ratolí)
//   ;
  
//  //Input Nombre Enemics
//  cp5.addTextfield("Introdueix el Nombre d'Enemics")
//   .setFont(font) 
//   .setPosition(200,300) 
//   .setSize(350,35) //Mides del component
//   .setText("13") //Text que es seteja ja escrit dins del component al principi
//   ;
   
//   //Butó per canviar de fase/fer enter de les opcions escollides per poder jugar al joc
//   cp5.addBang("Startgame")
//    .setFont(font) 
//    .setPosition(270,400)
//    .setSize(200,55)
//    ;
//}

//void Startgame()
//{
//  startPressed = true;
//}

//void inputsOff()
//{
//  cp5.remove("controlType"); //Aquesta funció de la llibreria serveix per eliminar els components que hem fet servir pels inputs
//  cp5.remove("Introdueix el Nombre d'Enemics"); 
//  cp5.remove("STARTGAME");
//}

//void menuScene()
//{
//  //Bucle per decidir a quina punta del mapa els enemics fan spawn
//  for (int i = 0; i < n; i++)
//  {
//    int a = (int)random(1,4); //Random int per poder fer servir el switch i assignar el valor a les coordennades X i Y de cada enemic de forma random
    
//    switch(a)
//    {
//      case 1:
//      x_pnj[i] = 0;
//      y_pnj[i] = 0;
//      break;
//      case 2:
//      x_pnj[i] = 0;
//      y_pnj[i] = height;
//      break;
//      case 3: 
//      x_pnj[i] = width;
//      y_pnj[i] = 0;
//      break;
//      case 4: 
//      x_pnj[i] = width;
//      y_pnj[i] = height;
//      break;
//    }
//  }
  
  
//  for (int i = 0; i < n; i++)
//  {
//    if (i < n/2)
//    {
//      alfa[i] = random(-0.01f,-0.02f); 
//    }
//    else
//    {
//      alfa[i] = random(0.008f,0.002f); 
//    }
//  } 
  
//  actualScene = Scene.GAME;
//}
