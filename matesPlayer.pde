//Pràctica AA1
//Variables
import controlP5.*;

int damageTime;

//player
float pjX;
float pjY;
float pjSpeed;
float pjSize;
PVector pjV;
int pjHp;
int[] pjDir = new int[2];
boolean checkColosions;
boolean timeDmg;

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
int n;
float[] x_pnj; 
float[] y_pnj;
float[] alfa; 
boolean[] isDead;

int counterNSpawning = second(), startN = second();
int m = 0;

//boss 
int bossHp;
float bossX;
float bossY;
float bossSpeed;
float bossSize;
PVector bossV;
int bossInvul;
int bossInvulCounter;

boolean followBoss;

//obstacles

float[] obsX = new float [6];
float[] obsY = new float [6];
float obsSize;

enum Scene{MENU, GAMEPLAY, BOSS, GAMEOVER}
Scene actualScene;

enum movementOptions{MOUSE, KEYS}
movementOptions movOptions;

enum gameOverState{WIN, LOSE}
gameOverState gameOver;

PVector testV;

//ControlP5 input
ControlP5 cp5;
boolean startPressed;
boolean inputsOn = true;


//Set-Up
void setup()
{
  //pantalla
  size (800, 800);
  
  //asegurarnos de que cuadrados/rectangulos aparecen al centro de las coordenadas
  rectMode(CENTER);
  
  actualScene = Scene.MENU;
  
  movOptions = movementOptions.MOUSE;
  
  checkColosions = false;
  
  //powerUps spawn
  
}



//Draw
void draw()
{
  
  background(0, 0, 0);
  
  switch (actualScene)
  {
    case MENU:
      if (inputsOn)
      {
        input(); //funcio inputs
        inputsOn = false;
      }
      
      n = int(cp5.get(Textfield.class,"Introdueix el Nombre Enemics").getText());
      if (startPressed)
      {
        inputsOff();
        startPressed = false;
        menuDone();
        pjInizilize();
        pnjInizilize();
        obsInizilize();
        powUpDownInizilize();
        actualScene = Scene.GAMEPLAY;
        damageTime = 1000*30 + millis();
        timeDmg = false;
        
        
      }
      break;
    case GAMEPLAY:
      
      //player mov
  
      if (movOptions == movementOptions.KEYS)
      {
        
        pjV = new PVector (pjDir[0], pjDir[1]);
        normalizePV(pjV);
        setMagnitude(pjV, pjSpeed);
        pjX += pjV.x;
        pjY += pjV.y;
        
      }
      else
      {
        
        pjV = new PVector (mouseX - pjX, mouseY - pjY);
        normalizePV(pjV);
        setMagnitude(pjV, pjSpeed);
        pjX += pjV.x;
        pjY += pjV.y;
      }   
      
      checkPlayerColl();
      checkPnj1Coll();
      checkPnj2Coll();
      
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
              for(int j  = 0; j < 6; j++)
              {
                powUpX[i] = random(50, 750);
                powUpY[i] = random(50, 750);
              
                if (checkDist(pjX, pjY, powUpX[i], powUpY[i]) > width/20 && checkDist(obsX[j], obsY[j], powUpX[i], powUpY[i]) > obsSize)
                {
                  canSpawn = true;
                }
              }
              
            }
            
          }
          //powerDowns spawnpoint
          for (int i = 0; i < 3; i++)
          {
            boolean canSpawn = false;
            
            while(!canSpawn)
            {
              for(int j  = 0; j < 6; j++)
              {
                powDownX[i] = random(50, 750);
                powDownY[i] = random(50, 750);
              
                if (checkDist(pjX, pjY, powDownX[i], powDownY[i]) > width/20 && checkDist(obsX[j], obsY[j], powDownX[i], powDownY[i]) > obsSize)
                {
                  canSpawn = true;
                }
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
        normalizePV(pnjV[0]);
        setMagnitude(pnjV[0], pnjS[0]);
        pnjX[0] += pnjV[0].x;
        pnjY[0] += pnjV[0].y;
      }
      
      //pnj1 calc per allunyarse dels enemics
      for (int i = 0; i < m; i++)
      {
        if (checkDist(pnjX[0], pnjY[0], x_pnj[i], y_pnj[i]) < 100)
        {
          pnjV[0] = new PVector (x_pnj[i] - pnjX[0], y_pnj[i] - pnjY[0]);
          normalizePV(pnjV[0]);
          setMagnitude(pnjV[0], 2);
          pnjX[0] -= pnjV[0].x;
          pnjY[0] -= pnjV[0].y;
        }
      }
      
      //pnj2 calc
      if (checkDist(pjX, pjY, pnjX[1], pnjY[1]) > dist[1])
      {
        pnjV[1] = new PVector (pjX - pnjX[1], pjY - pnjY[1]);
        normalizePV(pnjV[1]);
        setMagnitude(pnjV[1], pnjS[1]);
        pnjX[1] += pnjV[1].x;
        pnjY[1] += pnjV[1].y;
      }
      
      for (int i = 0; i < m; i++)
      {
        //codi per que el pnj2 perdi vida al colisionar, amb un counter per que no es mori automaticament, utilitzem la variable booleana invertida isDead per que no tingui en compte els enemic que ja estan morts
        if ( !isDead[i] && checkDist(pnjX[1], pnjY[1], x_pnj[i], y_pnj[i]) < width/25)
        {
          if (pnjInvulCounter < pnjInvul)
          {
            pnjInvulCounter++;
          }
          else
          {
            pnjInvulCounter = 0;
            pnj2Hp += 1;
          }
          //fem que la vida del pnj2 vagi cap adalt en comptes de cap avaix per ajudar a la creacio de la UI de la vida
          if (pnj2Hp == 20)
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
      
      if (powUpGot == 3 && checkDist(width/2, height/2, pjX, pjY) < 131)
        {
          //boss setup
          bossHp = 10;
          bossX = width/2;
          bossY = bossSize + height/30;
          bossSpeed = 1.5;
          bossSize = width/10;
          bossInvul = 20;
          bossInvulCounter = 20;
          followBoss = true;
          
          actualScene = Scene.BOSS;
        }
      
      if (checkColosions)
      {
        
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
          
          if (getMagnitude(pjV) == 0)
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
     
     //OBS RENDER
     fill(200, 200, 200);
     for (int i = 0; i < 6; i++)
     {
       if(i<3)
       {
         ellipse(obsX[i], obsY[i], obsSize, obsSize);
       }
       else
       {
         rect(obsX[i], obsY[i], obsSize, obsSize);
       }
     }
     
     if (powUpGot == 3)
     {
       fill(255, 0, 255);
       ellipse(width/2, height/2, width/4, height/4);
     }
     
      EnemySpawner();
      
      rectMode(CORNER);
      fill(255, 0, 0);
      rect(pnjX[1] - width/20, pnjY[1] - 50, width/10, width/40);
      fill(0, 255, 0);
      rect(pnjX[1] - width/20, pnjY[1] - 50, width/pnj2Hp - (pnj2Hp-10)*4.7, width/40);
      
      rectMode(CENTER);
      
      //pjHp RENDER
      for (int i = 1; i <= pjHp; i++)
      {
        fill(0, 255, 0);
        square(width/1.25 + i*width/20, 50,  width/25);
      }
          break;
        case BOSS:
        
          //player mov
  
          if (movOptions == movementOptions.KEYS)
          {
            
            pjV = new PVector (pjDir[0], pjDir[1]);
            normalizePV(pjV);
            setMagnitude(pjV, pjSpeed);
            pjX += pjV.x;
            pjY += pjV.y;
            
          }
          else
          {
            pjV = new PVector (mouseX - pjX, mouseY - pjY);
            normalizePV(pjV);
            setMagnitude(pjV, pjSpeed);
            pjX += pjV.x;
            pjY += pjV.y;
          }

          if (checkDist(pjX, pjY, pnjX[1], pnjY[1]) > dist[1])
          {
            pnjV[1] = new PVector (pjX - pnjX[1], pjY - pnjY[1]);
            normalizePV(pnjV[1]);
            setMagnitude(pnjV[1], pnjS[1]);
            pnjX[1] += pnjV[1].x;
            pnjY[1] += pnjV[1].y;
          }
          
          if(followBoss)
          {
            pnjV[0] = new PVector (bossX - pnjX[0], bossY - pnjY[0]);
            normalizePV(pnjV[0]);
            setMagnitude(pnjV[0], pnjS[0]);
            pnjX[0] += pnjV[0].x;
            pnjY[0] += pnjV[0].y;
            
            if (checkDist(bossX, bossY ,pnjX[0], pnjY[0]) < bossSize-20)
            {
              followBoss = !followBoss;
            }
            
          }else
          {
            pnjV[0] = new PVector (pjX - pnjX[0], pjY - pnjY[0]);
            normalizePV(pnjV[0]);
            setMagnitude(pnjV[0], pnjS[0]);
            pnjX[0] += pnjV[0].x;
            pnjY[0] += pnjV[0].y;
            
            if (checkDist(pjX, pjY ,pnjX[0], pnjY[0]) < pjSize)
            {
              followBoss = !followBoss;
            }
          }

          
          //boss calc
          bossV = new PVector (bossX - pnjX[1], bossY - pnjY[1]);
          normalizePV(bossV);
          setMagnitude(bossV, bossSpeed);
          bossX -= bossV.x;
          bossY -= bossV.y;
         
          //codi per que el pnj2 perdi vida al colisionar, amb un counter per que no es mori automaticament
          if (checkDist(pnjX[1], pnjY[1], bossX, bossY) < bossSize)
          {
            if (pnjInvulCounter < pnjInvul)
            {
              pnjInvulCounter++;
            }
            else
            {
              pnjInvulCounter = 0;
              pnj2Hp += 1;
            }
            //fem que la vida del pnj2 vagi cap adalt en comptes de cap avaix per ajudar a la creacio de la UI de la vida
            if (pnj2Hp == 20)
            {
              pnj2Hp = 10;
              pjHp--;
            }
          }
          
          //codi per que el boss perdi vida al colisionar, amb un counter per que no es mori automaticament
          if (checkDist(pjX, pjY, bossX, bossY) < bossSize || checkDist(pnjX[0], pnjY[0], bossX, bossY) < bossSize)
          {
            if (bossInvulCounter < bossInvul)
            {
              bossInvulCounter++;
            }
            else
            {
              bossInvulCounter = 0;
              bossHp += 1;
            }
            //fem que la vida del boss vagi cap adalt en comptes de cap avaix per ajudar a la creacio de la UI de la vida
            if (bossHp == 20)
            {
              actualScene = Scene.GAMEOVER;
            }
          }
          
          if (pjHp == 0)
          {
            actualScene = Scene.GAMEOVER;
          }
          
           //pj RENDER
          fill(0, 255, 0);
          ellipse(pjX, pjY, pjSize, pjSize);
          
          //pnj1 RENDER
          fill(0, 174, 230);
          ellipse(pnjX[0], pnjY[0], width/20, height/20);
          
          //pnj2 RENDER
          fill(174, 0, 174);
          ellipse(pnjX[1], pnjY[1], width/20, height/20);
          
          //boss RENDER
          fill(255, 0, 0);
          ellipse(bossX, bossY, bossSize, bossSize);
          
          //pnj2Hp RENDER
          rectMode(CORNER);
          fill(255, 0, 0);
          rect(pnjX[1] - width/20, pnjY[1] - 50, width/10, width/40);
          fill(0, 255, 0);
          rect(pnjX[1] - width/20, pnjY[1] - 50, width/pnj2Hp - (pnj2Hp - 10) * 4.7, width/40);
          
          //bossHp RENDER
          fill(255, 0, 0);
          rect(bossX - width/20, bossY - 50, width/10, width/40);
          fill(0, 255, 0);
          rect(bossX - width/20, bossY - 50, width/bossHp - (bossHp - 10) * 4.5, width/40);
          
          rectMode(CENTER);
          
         //pjHp RENDER
         for (int i = 1; i <= pjHp; i++)
         {
           fill(0, 255, 0);
           square(width/1.25 + i*width/20, 50,  width/25);
         }
          
          break;
        case GAMEOVER:
          
          break;
          
      }
      
      if (millis() >= damageTime && !timeDmg)
      {
        pjHp -= 1;
        timeDmg = true;
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
  return getMagnitude(new PVector (x1 - x2, y1 - y2)); 
}

void input()
{
  PFont font = createFont("arial",20); //Variable que indica la font que volem fer servir(Arial, mida 20) pels components d'aquesta llibreria
  cp5 = new ControlP5(this);
  
  //Butons per escollir el tipu de controls que es faran servir per la partida
  cp5.addRadioButton("controlType") //Creació d'element per escollir el tipu de controls pel joc
   .setFont(font) //Seteja la font que hem posat en variable anteriorment perque aquest component la faci servir(Arial, 20)
   .setPosition(200,200) //posicio dins la pantalla del component
   .setItemWidth(50) //Width dels butons que es defineixen seguidament
   .setItemHeight(40) //Height dels butons que es defineixen seguidament
   .addItem("Ratoli", 0) //Creador d'un botó "Ratolí" que definim com a 0
   .addItem("Teclat", 1) //Creador d'un botó "Teclat" que definim com a 1 (1 i 0 funcionen com un true / false.)
   .activate(0) //Element que seteja des del principi una de les dos opcions(en aquest cas la del ratolí)
   ;
  
  //Input Nombre Enemics
  cp5.addTextfield("Introdueix el Nombre Enemics")
   .setFont(font) 
   .setPosition(200,300) 
   .setSize(350,35) //Mides del component
   .setText("13") //Text que es seteja ja escrit dins del component al principi
   ;
   
   //Butó per canviar de fase/fer enter de les opcions escollides per poder jugar al joc
   cp5.addBang("Startgame")
    .setFont(font) 
    .setPosition(270,400)
    .setSize(200,55)
    ;
}

float getMagnitude(PVector v)
{
  return sqrt(v.x*v.x + v.y*v.y);
}

void normalizePV(PVector v)
{
  float mag = getMagnitude(v);
  
  if(mag != 0)
  {
    v.x /= mag;
    v.y /= mag;
  }
}

void setMagnitude(PVector v, float mag)
{
  v.x *= mag;
  v.y *= mag;
}

void menuDone()
{
  x_pnj = new float[n];
  y_pnj = new float[n];
  alfa = new float[n];
  isDead = new boolean[n];
  
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
}


void powUpDownInizilize()
{
    powsSpawned = false;
    powUpGot = 0;
    
    for (int i = 0; i < 3; i++)
    {
      powUpX[i] = 1000000;
    }
    
    for (int i = 0; i < 3; i++)
    {
      powDownX[i] = 100000;
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
}

void pjInizilize()
{
    //pj stats
    pjSize = width/20;
    pjSpeed = 7;
    pjHp = 3;
    
    pjX = width/2;
    pjY = height/2;
}

void obsInizilize()
{
  
  obsSize = width/8;
  
  for (int i = 0; i < 6; i++)
  {
    obsX[i] = random(50, 750);
    obsY[i] = random(50, 750);
  }
  
}

void pnjInizilize()
{

    //pnjs stats
    pnjS[0] = 5;
    //0 porque espera a ser recogido
    pnjS[1] = 0;
    dist[0] = 125;
    dist[1] = 75;
    pnj2Hp = 10;
    
    pnjInvul = 7;
    pnjInvulCounter = pnjInvul;
    
    //pnjs spawnpoint
    pnjX[0] = width/2;
    pnjY[1] = 0;
    pnjX[1] = random(750);
    pnjY[1] = random(750);

}

void Startgame()
{
  startPressed = true;
}

void inputsOff()
{
  cp5.remove("controlType"); //Aquesta funció de la llibreria serveix per eliminar els components que hem fet servir pels inputs
  cp5.remove("Introdueix el Nombre Enemics"); 
  cp5.remove("Startgame");
}

void checkPlayerColl()
{
  // calc pj limits
  float objL = pjX - pjSize/2;
  float objR = pjX + pjSize/2;
  float objT = pjY - pjSize/2;
  float objB = pjY + pjSize/2;
 
  for(int i = 0; i < 6; i++)
  {
      //calc obstacle limits
      float obsL = obsX[i] - obsSize/2;
      float obsR = obsX[i] + obsSize/2;
      float obsT = obsY[i] - obsSize/2;
      float obsB = obsY[i] + obsSize/2;
      
      // collision logic
      if(objR >obsL && objL < obsR && objB > obsT && objT < obsB) 
      {
          pjV = new PVector (obsX[i] - pjX, obsY[i] - pjY);
          normalizePV(pjV);
          setMagnitude(pjV, pjSpeed);
          pjX -= pjV.x;
          pjY -= pjV.y;
      }
  }

}

void checkPnj1Coll()
{
  //calc pnj1 limits
  float objL = pnjX[0] - pjSize/2;
  float objR = pnjX[0] + pjSize/2;
  float objT = pnjY[0] - pjSize/2;
  float objB = pnjY[0] + pjSize/2;
 
  for(int i = 0; i < 6; i++)
  {
      //calc obstacle limits
      float obsL = obsX[i] - obsSize/2;
      float obsR = obsX[i] + obsSize/2;
      float obsT = obsY[i] - obsSize/2;
      float obsB = obsY[i] + obsSize/2;
      
      // collision logic
      if(objR >obsL && objL < obsR && objB > obsT && objT < obsB) 
      {
          pnjV[0] = new PVector (obsX[i] - pnjX[0], obsY[i] - pnjY[0]);
          normalizePV(pnjV[0]);
          setMagnitude(pnjV[0], pnjS[0]);
          pnjX[0] -= pnjV[0].x;
          pnjY[0] -= pnjV[0].y;
      }
  }

}

void checkPnj2Coll()
{
  // calc pnj2 limits
  float objL = pnjX[1] - pjSize/2;
  float objR = pnjX[1] + pjSize/2;
  float objT = pnjY[1] - pjSize/2;
  float objB = pnjY[1] + pjSize/2;
 
  for(int i = 0; i < 6; i++)
  {
      //calc obstacle limits
      float obsL = obsX[i] - obsSize/2;
      float obsR = obsX[i] + obsSize/2;
      float obsT = obsY[i] - obsSize/2;
      float obsB = obsY[i] + obsSize/2;
      
      // collision logic
      if(objR >obsL && objL < obsR && objB > obsT && objT < obsB) 
      {
          pnjV[1] = new PVector (obsX[i] - pnjX[1], obsY[i] - pnjY[1]);
          normalizePV(pnjV[1]);
          setMagnitude(pnjV[1], pnjS[1]);
          pnjX[1] -= pnjV[1].x;
          pnjY[1] -= pnjV[1].y;
          
          //codi per que el pnj2 perdi vida al colisionar, amb un counter per que no es mori automaticament
          if (pnjInvulCounter < pnjInvul)
            {
              pnjInvulCounter++;
            }
            else
            {
              pnjInvulCounter = 0;
              pnj2Hp += 1;
            }
            //fem que la vida del pnj2 vagi cap adalt en comptes de cap avaix per ajudar a la creacio de la UI de la vida
            if (pnj2Hp == 20)
            {
              pnj2Hp = 10;
              pjHp--;
            }
      }
  }

}
