//Pràctica AA1
//Variables
import controlP5.*;

int damageTime;

//player
float pjX;//posicio X del player
float pjY;//posicio Y del player
float pjSpeed;//velocitat del player
float pjSize;//tamany del player
PVector pjV;//vector que utilitzem per moure el player
int pjHp;// vida del player
int[] pjDir = new int[2]; //array dints que serveix per fer controls amb teclats
boolean checkColosions;// booleana per saber quan mirar certes collisions
boolean timeDmg;// boleana per saber si el jugador ha rebut el mal per temps
int score;// puntuacio del player

//pnjs (aliats)
float[] pnjX = new float [2];//posicio X dels pnjs
float[] pnjY = new float [2];//posicio Y dels pnjs
float[] pnjS = new float [2];//velocitat dels pnjs
int[] dist = new int [2];// distancia a la que es queden del player
PVector[] pnjV = new PVector [2];// vector que fem servir per moure els pnjs
int pnj2Hp;//hp del pnj2
int pnjInvul;//int que senyala el temps que no rebra mal el pnj2 no revi mal
int pnjInvulCounter;// conta

//power ups
float[] powUpX = new float [3];//posicio x dels power ups
float[] powUpY = new float [3];//posicio y dels power ups
boolean[] powUpGet = new boolean [3];
int powUpGot; //int que cuenta los power ups conseguidos para saber cuando spawnear el portal
boolean powers; //bool para spawnear los powerups/downs
boolean powsSpawned; //bool para ver si ya han spawneado los powerUps/Downs

//power downs
float[] powDownX = new float [3];//posicio x dels power downs
float[] powDownY = new float [3];//posicio y dels power downs
boolean[] powDownGet = new boolean [3];

//PNJS N (enemics)
int n;//nombre denemics
float[] x_pnj; //array de posicions x dels enemics
float[] y_pnj;//array de posicions y dels enemics
float[] alfa; //"velocitat" dels enemics, mes especificament la quantitat de "pasos que han de fer per arribar al player"
boolean[] isDead;//booleana per comprobar si un enemic esta mort

//Variables fetes
int counterNSpawning = second(), startN = second();
int m = 0;

//boss 
int bossHp;//vida del boss
float bossX;//posicio x del boss
float bossY;//posicio y del boss
float bossSpeed;//velocitat del boss
float bossSize;// tamany del boss
PVector bossV;// vector per moure el boss
int bossInvul;// mateixa utilitat que amb el pnj2
int bossInvulCounter;// mateixa utilitat que amb el pnj2

boolean followBoss;// booleana per saber com ha d'actuar el pnj1 amb el boss

//obstacles

float[] obsX = new float [6];//array de posicions x dels obstacles
float[] obsY = new float [6];//array de posicions y dels obstacles
float obsSize;// tamany dels obstacles

enum Scene{MENU, GAMEPLAY, BOSS, GAMEOVER}// enum que ens deixa saber a quina escena estem
Scene actualScene;

enum movementOptions{MOUSE, KEYS}// enum que ens deixa saber quins controls utilitza el jugador
movementOptions movOptions;

enum gameOverState{WIN, LOSE}// enum que ens deixa saber si el jugador ha perdut o guanyat
gameOverState gameOver;

//ControlP5 input
ControlP5 cp5;
boolean startPressed;
boolean inputsOn = true;
boolean tryAgain = false;


//Set-Up
void setup()
{
  //pantalla
  size (800, 800);
  
  //asegurarnos de que cuadrados/rectangulos aparecen al centro de las coordenadas
  rectMode(CENTER);
  
  actualScene = Scene.MENU;
  //asegurarnos de que la booleana te un valro per que no causi errors
  checkColosions = false;
  
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
      
      switch(int(cp5.get(RadioButton.class,"controlType").getValue()))
      {
        case 0:
          movOptions = movementOptions.MOUSE;
          break;
        case 1:
          movOptions = movementOptions.KEYS;
          break;
      }
      if (startPressed)
      {
        inputsOff();
        startPressed = false;
        score = 0;
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
      
      Score();
      
      //player mov
      if (movOptions == movementOptions.KEYS)
      {
        //moviment amb teclat        
        pjV = new PVector (pjDir[0], pjDir[1]); //creem un nou vector 2D amb les direccions X e Y del player
        normalizePV(pjV);//normalitzem el vector per que no vagi mes rapid en diagonal
        setMagnitude(pjV, pjSpeed);//actualitzem la magnitud del vector a la velocitat desitjada
        pjX += pjV.x;//movem la x del player
        pjY += pjV.y;//movem la y del player
        
      }
      else
      {
        //moviment amb ratoli
        pjV = new PVector (mouseX - pjX, mouseY - pjY);//creem un vector 2d amb el player y el ratoli
        normalizePV(pjV);
        setMagnitude(pjV, pjSpeed);
        pjX += pjV.x;
        pjY += pjV.y;
      }   
      
      checkPlayerColl();//mirem colisions del player amb obstacles
      checkPnj1Coll();//mirem colisions del pnj1 amb obstacles
      checkPnj2Coll();//mirem colisions del pnj2 amb obstacles
      
      //check if pnj2 picked
      if (checkDist(pjX, pjY, pnjX[1], pnjY[1]) < 50) //check sense 
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
            
            while(!canSpawn)// con este bucle nos aseguramos de que no spawneen encima del jugador y de los obstaculos, por lo tanto coleccionandolos automaticamente.
            {
              powUpX[i] = random(50, 750);
              powUpY[i] = random(50, 750);
              for(int j  = 0; j < 6; j++)
              {
                if (checkDist(pjX, pjY, powUpX[i], powUpY[i]) > width/20 && checkDist(obsX[j], obsY[j], powUpX[i], powUpY[i]) > (obsSize + width/5))
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
            
            while(!canSpawn) //con este bucle nos aseguramos de que no spawneen encima del jugador y de los obstaculos, por lo tanto coleccionandolos automaticamente.
            {
              powDownX[i] = random(50, 750);
              powDownY[i] = random(50, 750);
              for(int j  = 0; j < 6; j++)
              {
                if (checkDist(pjX, pjY, powDownX[i], powDownY[i]) > width/20 && checkDist(obsX[j], obsY[j], powDownX[i], powDownY[i]) > (obsSize + width/5))
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
      
      //pnj1 movment
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
      
      //pnj2 movement
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
        gameOver = gameOverState.LOSE;
        inputsOn = true;
      }
      
      for (int i = 0; i < m; i++)
      {
        if(!isDead[i] && checkDist(pjX,pjY,x_pnj[i],y_pnj[i]) < pjSize/1.25)
        {
          isDead[i] = true;
          score++;
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
      
      //mirem si el jugador esta aprop del portal y la condicio per que apareixi el mateix y inicialitzem el boss
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
      
      if (checkColosions)//collisions amb els powerUps/Downs utilitzant distancies
      {
        
          for (int i = 0; i < 3; i++)
        {
          if (!powUpGet[i])
          {
            if (checkDist(pjX, pjY, powUpX[i], powUpY[i]) < pjSize)
            {
              powUpGet[i] = true;
              powUpGot++;
              score++;
              
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
    
     //Render enemics
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
     
     //Render del portal
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
        PFont font = createFont("arial",20);
        textFont(font);
        text("Vides:",(width/1.5 + width/15)-80, 60);
      }
          break;
        case BOSS:
          Score();
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
          
          if(followBoss)//aqui el pnj1 varia entre aproparse al boss y al player
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
              score++;
            }
  
            if (bossHp == 20)
            {
              actualScene = Scene.GAMEOVER;
              gameOver = gameOverState.WIN;
              inputsOn = true;
            }
          }
          
          if (pjHp == 0)
          {
            actualScene = Scene.GAMEOVER;
            gameOver = gameOverState.LOSE;
            inputsOn = true;
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
          Score();
          if (gameOver == gameOverState.LOSE)
          {
            PFont font = createFont("arial",40);
            fill(255);
            textFont(font);
            text( "Game Over",width/3, height/3);
            if(inputsOn)
            {
              finalInput();
              inputsOn = false;
            }
          }
          else
          {
            PFont font = createFont("arial",40);
            fill(255);
            textFont(font);
            text("You Won!!! Thanks For Playing!",width/6, height/3);
            if(inputsOn)
            {
              finalInput();
              inputsOn = false;
            }
          }
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
         score++;
        
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
  return getMagnitude(new PVector (x1 - x2, y1 - y2)); //mirem distancia entre dos posicions
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
  x_pnj = new float[n]; //Tots els arrays de les variables d'enemics ara es poden iniciar ja que ja tenim n (nombre d'enemics)
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
      x_pnj[i] = width-50;
      y_pnj[i] = height/2-50;
      break;
      case 2:
      x_pnj[i] = 50;
      y_pnj[i] = height/2-50;
      break;
      case 3: 
      x_pnj[i] = width/2-50;
      y_pnj[i] = 50;
      break;
      case 4: 
      x_pnj[i] = width/2-50;
      y_pnj[i] = height-50;
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
    
    
    //movem els powerUps/Downs per que quan tornis a comencar la prtida no els agafis sense poderlso veure
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
    
    boolean canSpawn = false;
            
            while(!canSpawn)
            {
              for(int j  = 0; j < 6; j++)
              {
                obsX[i] = random(50, 750);
                obsY[i] = random(50, 750);
              
                if (checkDist(pjX, pjY, obsX[i], obsY[i]) > obsSize && checkDist(obsX[j], obsY[j], pnjX[1], pnjY[1]) > (obsSize + width/10))
                {
                  canSpawn = true;
                }
              }
            }
    
    
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

void Startgame() //Funció que es crida al clicar el botó per començar el joc que serveix per posar en true una bool
{
  startPressed = true;
}

void inputsOff() //Funció per borrar el botons i l'input del menú inicial perquè no es quedin a la següent escena
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
 
  for(int i = 0; i < 6; i++)//bucle per comprobar colisions amb cada un dels obstacles
  {
      //calc obstacle limits
      float obsL = obsX[i] - obsSize/2;
      float obsR = obsX[i] + obsSize/2;
      float obsT = obsY[i] - obsSize/2;
      float obsB = obsY[i] + obsSize/2;
      
      // collision logic
      if(objR >obsL && objL < obsR && objB > obsT && objT < obsB) 
      {
          //moviment cap a fora del obstacle
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

void finalInput() //Funció que es crida a l'última pantalla per crear el botó que permet al jugador tornar a jugar
{
  PFont font = createFont("arial",20);  
  cp5 = new ControlP5(this);

  cp5.addBang("Try_Again")
    .setFont(font) 
    .setPosition(270,400)
    .setSize(200,55)
    ;
}

void Try_Again() //Funció que es crida al cliar el botó de Try_Again i serveix per cridar a la funció que borra a aqest i reiniciar algunes variable i l'escena
{
  finalInputOff();
  tryAgain = true;
  inputsOn = true;
  actualScene = Scene.MENU;
}

void finalInputOff() //Funció per borrar el botó que permet al jugador tornar a jugar perquè aquest no es quedi a les següents escenes
{
  cp5.remove("Try_Again");
}

void Score() //Funció per fer sortir a la pantalla la puntuació del jugador, de color blau i a la part superior esquerra.
{
  PFont font = createFont("arial",20);  
  fill(0, 0, 255);
  textFont(font);
  text("Score:",50,50);

  textFont(font);
  text(score,115,50);
}
