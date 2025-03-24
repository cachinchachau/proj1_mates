//Pràctica AA1
//Variables
import controlP5.*;

//player
float pjX;
float pjY;
float pjSpeed;
float pjSize;
PVector pjV;
int pjHp;
int[] pjDir = new int[2];
boolean checkColosions;

//pnjs (aliats)
float[] pnjX = new float [2];
float[] pnjY = new float [2];
float[] pnjS = new float [2];
int[] dist = new int [2];
PVector[] pnjV = new PVector [2];
int pnj2Hp;
int pnjInvul;
int pnjInvulCounter;

//power ups
float[] powUpX = new float [3];
float[] powUpY = new float [3];
boolean[] powUpGet = new boolean [3];
int powUpGot; //int que cuenta los power ups conseguidos para saber cuando spawnear el portal
boolean powers; //bool para spawnear los powerups/downs
boolean powsSpawned; //bool para ver si ya han spawneado los powerUps/Downs

//power downs
float[] powDownX = new float [3];
float[] powDownY = new float [3];
boolean[] powDownGet = new boolean [3];

//PNJS N (enemics)
int n = 5;
float[] x_pnj = new float[n]; //5 momentani, s'ha de fer lo de input nº enemics
float[] y_pnj = new float[n]; //5 momentani, s'ha de fer lo de input nº enemics
float[] alfa = new float[n]; //5 momentani, s'ha de fer lo de input nº enemics
boolean[] isDead = new boolean[n];

int counterNSpawning = second(), startN = second();
int m = 0;

enum Scene{MENU, GAMEPLAY, BOSS, GAMEOVER}
Scene actualScene;

enum movementOptions{MOUSE, KEYS}
movementOptions movOptions;

//ControlP5 input
ControlP5 cp5;


//Set-Up
void setup()
{
  //pantalla
  size (800, 800);
  
  //asegurarnos de que cuadrados/rectangulos aparecen al centro de las coordenadas
  rectMode(CENTER);
  
  actualScene = Scene.GAMEPLAY;
  
  movOptions = movementOptions.KEYS;
  
  checkColosions = false;
  
  //pj stats
  pjSize = width/20;
  pjSpeed = 7;
  pjHp = 3;
  
  pjX = width/2;
  pjY = height/2;
  
  //pnjs stats
  pnjS[0] = 5;
  //0 porque espera a ser recogido
  pnjS[1] = 0;
  dist[0] = 125;
  dist[1] = 75;
  pnj2Hp = 10;
  
  pnjInvul = 30;
  pnjInvulCounter = pnjInvul;
  
  //pnjs spawnpoint
  pnjX[0] = width/2;
  pnjY[1] = 0;
  pnjX[1] = random(750);
  pnjY[1] = random(750);
  
  //powerUps spawn
  powsSpawned = false;
  
  for (int i = 0; i < 3; i++)
  {
    powUpX[i] = 10000;
    powUpY[i] = 10000;
  }
  //powerDowns spawnpoint
  for (int i = 0; i < 3; i++)
  {
    powDownX[i] = 10000;
    powDownY[i] = 10000;
  }
  
  //powerUps get = false
  for (int i = 0; i < 3; i++)
  {
    powUpGet[i] = false;
  }
  //powerDowns get = false
  for (int i = 0; i < 3; i++)
  {
    powDownGet[i] = false;
  }
  
  //Bucle per decidir a quina punta del mapa els enemics fan spawn
  for (int i = 0; i < n; i++)
  {
    int a = (int)random(1,4); //Random int per poder fer servir el switch i assignar el valor a les coordennades X i Y de cada enemic de forma random
    
    switch(a)
    {
      case 1:
      x_pnj[i] = 0;
      y_pnj[i] = 0;
      break;
      case 2:
      x_pnj[i] = 0;
      y_pnj[i] = height;
      break;
      case 3: 
      x_pnj[i] = width;
      y_pnj[i] = 0;
      break;
      case 4: 
      x_pnj[i] = width;
      y_pnj[i] = height;
      break;
    }
  }
  
  for (int i = 0; i < n; i ++)
  {
    isDead[i] = false;
  }
  
  for (int i = 0; i < n; i++)
  {
    if (i < n/2)
    {
      alfa[i] = random(-0.01f,-0.02f); 
    }
    else
    {
      alfa[i] = random(0.008f,0.002f); 
    }
  }  

  //input(); //funcio inputs

}



//Draw
void draw()
{
  
  background(0, 0, 0);
  
  switch (actualScene)
  {
    case MENU:
      
      break;
    case GAMEPLAY:
      //player mov
  
      if (movOptions == movementOptions.KEYS)
      {
        
        pjV = new PVector (pjDir[0], pjDir[1]);
        pjV = pjV.normalize().setMag(pjSpeed);
        pjX += pjV.x;
        pjY += pjV.y;
        
      }
      else
      {
        
        pjV = new PVector (mouseX - pjX, mouseY - pjY);
        pjV = pjV.normalize().setMag(pjSpeed); //fer calcs sense .normalize y .setMag
        pjX += pjV.x;
        pjY += pjV.y;
        
      }   
      
      //check if pnj2 picked
      if (checkDist(pjX, pjY, pnjX[1], pnjY[1]) < 50) //check sense .mag
      {
        //ahora te sigue
        pnjS[1] = 3;
        powers = true;
        
        if (!powsSpawned)
        {
          
          //spawnPows
          for (int i = 0; i < 3; i++)
          {
            boolean canSpawn = false;
            
            while(!canSpawn)// con este bucle nos aseguramos de que no spawneen encima del jugador, por lo tanto coleccionandolos automaticamente.
            {
              powUpX[i] = random(50, 750);
              powUpY[i] = random(50, 750);
              
              if (checkDist(pjX, pjY, powUpX[i], powUpY[i]) > width/20)
              {
                canSpawn = true;
              }
              
            }
            
          }
          //powerDowns spawnpoint
          for (int i = 0; i < 3; i++)
          {
            boolean canSpawn = false;
            
            while(!canSpawn)
            {
              powDownX[i] = random(50, 750);
              powDownY[i] = random(50, 750);
              
              if (checkDist(pjX, pjY, powDownX[i], powDownY[i]) > width/20)
              {
                canSpawn = true;
              }
              
            }
            
          }
          powsSpawned = true;
        }
        
      }
      
      //CALC
      
      
      //pnj1 calc
      if (checkDist(pjX, pjY, pnjX[0], pnjY[0]) > dist[0])
      {
        pnjV[0] = new PVector (pjX - pnjX[0], pjY - pnjY[0]);
        pnjV[0] = pnjV[0].normalize().setMag(pnjS[0]); //fer calcs sense .normalize y .setMag
        pnjX[0] += pnjV[0].x;
        pnjY[0] += pnjV[0].y;
      }
      
      for (int i = 0; i < m; i++)
      {
        if (checkDist(pnjX[0], pnjY[0], x_pnj[i], y_pnj[i]) < 100)
        {
          pnjV[0] = new PVector (x_pnj[i] - pnjX[0], y_pnj[i] - pnjY[0]);
          pnjV[0] = pnjV[0].normalize().setMag(2); //fer calcs sense .normalize y .setMag
          pnjX[0] -= pnjV[0].x;
          pnjY[0] -= pnjV[0].y;
        }
      }
      
      //pnj2 calc
      if (checkDist(pjX, pjY, pnjX[1], pnjY[1]) > dist[1])
      {
        pnjV[1] = new PVector (pjX - pnjX[1], pjY - pnjY[1]);
        pnjV[1] = pnjV[1].normalize().setMag(pnjS[1]); //fer calcs sense .normalize y .setMag
        pnjX[1] += pnjV[1].x;
        pnjY[1] += pnjV[1].y;
      }
      
      for (int i = 0; i < m; i++)
      {
        if (checkDist(pnjX[1], pnjY[1], x_pnj[i], y_pnj[i]) < width/25)
        {
          if (pnjInvulCounter < pnjInvul)
          {
            pnjInvulCounter++;
          }
          else
          {
            pnjInvulCounter = 0;
            pnj2Hp -= 1;
          }

          if (pnj2Hp == 0)
          {
            pnj2Hp = 10;
            pjHp--;
          }
        }
      }
      
      if (pjHp == 0)
      {
        actualScene = Scene.GAMEOVER;
      }
      
      for (int i = 0; i < m; i++)
      {
        if(!isDead[i] && checkDist(pjX,pjY,x_pnj[i],y_pnj[i]) < pjSize/1.25)
        {
          isDead[i] = true;
        }
      }
      
      // p(alfa) = PNJ + alfa * PJ --> p(alfa) = (1-alfa) * PNJ + alfa * PJ
      for(int i = 0; i < m/2; i++)
      {
        if (!isDead[i] &&checkDist(pjX,pjY,x_pnj[i],y_pnj[i]) >= width/2)
        {
          x_pnj[i] = (1.0 - (-alfa[i])) * x_pnj[i] + (-alfa[i]) * pjX;
          y_pnj[i] = (1.0 - (-alfa[i])) * y_pnj[i] + (-alfa[i]) * pjY; 
        }
        else if(!isDead[i])
        {
          x_pnj[i] = (1.0 - alfa[i]) * x_pnj[i] + alfa[i] * pjX;
          y_pnj[i] = (1.0 - alfa[i]) * y_pnj[i] + alfa[i] * pjY; 
        }
      }
        for(int i = m/2; i < m/4 + m/2; i++)
      {
        if (!isDead[i])
        {
          x_pnj[i] = (1.0 - alfa[i]) * x_pnj[i] + alfa[i] * pnjX[0];
          y_pnj[i] = (1.0 - alfa[i]) * y_pnj[i] + alfa[i] * pnjY[0];    
        }
     
      }
        for(int i = m/2+m/4; i < m; i++)
      {
        if (!isDead[i])
        {
          x_pnj[i] = (1.0 - alfa[i]) * x_pnj[i] + alfa[i] * pnjX[1];
          y_pnj[i] = (1.0 - alfa[i]) * y_pnj[i] + alfa[i] * pnjY[1];
        }
      }
      
      if (checkColosions)
      {
        
        if (powUpGot == 3 && checkDist(width/2, height/2, pjX, pjY) < 154)
        {
          actualScene = Scene.BOSS;
        }
        
          for (int i = 0; i < 3; i++)
        {
          if (!powUpGet[i])
          {
            if (checkDist(pjX, pjY, powUpX[i], powUpY[i]) < pjSize)
            {
              powUpGet[i] = true;
              powUpGot++;
              
              switch(i)
              {
                case 0:
                  pjSize *= 1.5;
                  break;
                case 1:
                  pnjS[0] += 2;
                  pnjS[1] += 2;
                  break;
                case 2:
                  pjSpeed += 3;
                  break;
              }
            }
          }
          
          if (pjV.mag() == 0)
          {
            checkColosions = false;
          }
      }
      
      
      //powerDowns
      for (int i = 0; i < 3; i++)
      {
        if (!powDownGet[i])
        {
          if (checkDist(pjX, pjY, powDownX[i], powDownY[i]) < pjSize) 
          {
            powDownGet[i] = true;
            
            switch(i)
              {
                case 0:
                  pjSize /= 1.5;
                  break;
                case 1:
                  pnjS[0] -= 2;
                  pnjS[1] -= 2;
                  break;
                case 2:
                  pjSpeed -= 3;
                  break;
              }
              
          }
        }
      }
    
      }
      
      
      //RENDERS
      
      //portal
      if (powUpGot == 3)// miramos la condicion para crear el portal
      {
        fill(255, 0, 255);
        ellipse(width/2, height/2, width/3, width/3);
      }
      
      //pj
      fill(0, 255, 0);
      ellipse(pjX, pjY, pjSize, pjSize);
      
      //pnj1
      fill(0, 174, 230);
      ellipse(pnjX[0], pnjY[0], width/20, height/20);
      fill(174, 0, 174);
      
      //pnj2
      ellipse(pnjX[1], pnjY[1], width/20, height/20);
      
      //powerups
      fill(255, 255, 255);
      for (int i = 0; i < 3 && powers ; i++)
      {
        if (!powUpGet[i])
        {
          square(powUpX[i], powUpY[i], 20);
        }
      }
      
      //powerdowns
      fill(255);
      for (int i = 0; i < 3 && powers ; i++)
      {
        if (!powDownGet[i])
        {
          square(powDownX[i], powDownY[i], 20);
        }
      }
    
     //Draw els enemics
     if (m > 0)
     {
       for (int i = 0; i < m; i++)
       {
         
         if (!isDead[i])
         {
           fill(255,0,0);
           ellipse(x_pnj[i],y_pnj[i], width/25, height/25);
         }
    
       }
     }
     
      EnemySpawner();
          break;
        case BOSS:
          //player mov
  
          if (movOptions == movementOptions.KEYS)
          {
            
            pjV = new PVector (pjDir[0], pjDir[1]);
            pjV = pjV.normalize().setMag(pjSpeed);
            pjX += pjV.x;
            pjY += pjV.y;
            
          }
          else
          {
            
            pjV = new PVector (mouseX - pjX, mouseY - pjY);
            pjV = pjV.normalize().setMag(pjSpeed); //fer calcs sense .normalize y .setMag
            pjX += pjV.x;
            pjY += pjV.y;
            
          }
          
          for (int i = 0; i < 2; i++)
          {
            if (checkDist(pjX, pjY, pnjX[i], pnjY[i]) > dist[i])
            {
              pnjV[i] = new PVector (pjX - pnjX[i], pjY - pnjY[i]);
              pnjV[i] = pnjV[i].normalize().setMag(pnjS[i]); //fer calcs sense .normalize y .setMag
              pnjX[i] += pnjV[i].x;
              pnjY[i] += pnjV[i].y;
            }
          }
          
           //pj
          fill(0, 255, 0);
          ellipse(pjX, pjY, pjSize, pjSize);
          
          //pnj1
          fill(0, 174, 230);
          ellipse(pnjX[0], pnjY[0], width/20, height/20);
          fill(174, 0, 174);
          
          //pnj2
          ellipse(pnjX[1], pnjY[1], width/20, height/20);
          
          break;
        case GAMEOVER:
          
          break;
          
      }
      
      
}


//EVENTOS
void EnemySpawner()
{
  if (second() >= counterNSpawning+2 && m < n)
  {
      m++;
      counterNSpawning = second();
  }
}

void mouseMoved()
{
  
  //COLLISIONES  
  //powerUps
  for (int i = 0; i < 3; i++)
  {
    if (!powUpGet[i])
    {
      if (checkDist(pjX, pjY, powUpX[i], powUpY[i]) < pjSize)
      {
        powUpGet[i] = true;
         powUpGot++;
        
        switch(i)
        {
          case 0:
            pjSize *= 1.5;
            break;
          case 1:
            pnjS[0] += 2;
            pnjS[1] += 2;
            break;
          case 2:
            pjSpeed += 3;
            break;
        }
      }
    }
  }
  
  //powerDowns
  for (int i = 0; i < 3; i++)
  {
    if (!powDownGet[i])
    {
      if (checkDist(pjX, pjY, powDownX[i], powDownY[i]) < pjSize/1.25) //dividimos entre 1,25 ya que sino lo hacemos al detectar al jugador cuando ha tenido su tama;o augmentado no queda bien
      {
        powDownGet[i] = true;
        
        switch(i)
          {
            case 0:
              pjSize /= 1.5;
              break;
            case 1:
              pnjS[0] -= 2;
              pnjS[1] -= 2;
              break;
            case 2:
              pjSpeed -= 3;
              break;
          }
      }
    }
  }
  
}

void keyPressed()
{
  
  checkColosions = true;
  
  switch(keyCode)
  {
    case UP:
      pjDir[1] = -1;
      break;
    case DOWN:
      pjDir[1] = 1;
      break;
    case LEFT:
      pjDir[0] = -1;
      break;
    case RIGHT:
      pjDir[0] = 1;
      break;
    
  }

}

void keyReleased()
{
  
  switch(keyCode)
  {
    case UP:
      pjDir[1] = 0;
      break;
    case DOWN:
      pjDir[1] = 0;
      break;
    case LEFT:
      pjDir[0] = 0;
      break;
    case RIGHT:
      pjDir[0] = 0;
      break;
    
  }

}

float checkDist(float x1, float y1, float x2, float y2)
{
  return (new PVector (x1 - x2, y1 - y2).mag()); 
}



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
//   cp5.addBang("START GAME")
//    .setFont(font) 
//    .setPosition(270,400)
//    .setSize(200,55)
//    ;
//}
