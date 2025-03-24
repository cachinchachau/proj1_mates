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
int score;

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
boolean tryAgain = false;


//Set-Up
void setup()
{
  //pantalla
  size (800, 800);
  
  //asegurarnos de que cuadrados/rectangulos aparecen al centro de las coordenadas
  rectMode(CENTER);
  
  actualScene = Scene.MENU;
    
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
        menuDone();
        pjInizilize();
        pnjInizilize();
        powUpDownInizilize();
        actualScene = Scene.GAMEPLAY;  
      }
      break;
    case GAMEPLAY:
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
        normalizePV(pnjV[0]);
        setMagnitude(pnjV[0], pnjS[0]);
        pnjX[0] += pnjV[0].x;
        pnjY[0] += pnjV[0].y;
      }
      
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
        if (checkDist(pnjX[1], pnjY[1], x_pnj[i], y_pnj[i]) < width/25)
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
        if (!isDead[i] &&checkDist(pjX,pjY,x_pnj[i],y_pnj[i]) >= width/4)
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
        square(width/1.5 + i*width/15, 50,  width/25);
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
            
            pjV = new PVector (pjDir[0], pjDir[1]);
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
  
            if (pnj2Hp == 20)
            {
              pnj2Hp = 10;
              pjHp--;
            }
          }
          
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
           square(width/1.5 + i*width/15, 50,  width/25);
           PFont font = createFont("arial",20);
           textFont(font);
           text("Vides:",(width/1.5 + width/15)-80, 60);
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

void finalInput()
{
  PFont font = createFont("arial",20);  
  cp5 = new ControlP5(this);

  cp5.addBang("Try_Again")
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
  score = 0;
  
  //Bucle per decidir a quina punta del mapa els enemics fan spawn
  for (int i = 0; i < n; i++)
  {
    int a = (int)random(1,4); //Random int per poder fer servir el switch i assignar el valor a les coordennades X i Y de cada enemic de forma random
    
    switch(a)
    {
      case 1:
      x_pnj[i] = width;
      y_pnj[i] = height/2;
      break;
      case 2:
      x_pnj[i] = 0;
      y_pnj[i] = height/2;
      break;
      case 3: 
      x_pnj[i] = width/2;
      y_pnj[i] = 0;
      break;
      case 4: 
      x_pnj[i] = width/2;
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

void Try_Again()
{
  finalInputOff();
  tryAgain = true;
  inputsOn = true;
  actualScene = Scene.MENU;
}

void finalInputOff()
{
  cp5.remove("Try_Again");
}

void inputsOff()
{
  cp5.remove("controlType"); //Aquesta funció de la llibreria serveix per eliminar els components que hem fet servir pels inputs
  cp5.remove("Introdueix el Nombre Enemics"); 
  cp5.remove("Startgame");
}

void Score()
{
  PFont font = createFont("arial",20);  
  fill(255);
  textFont(font);
  text("Score:",50,50);

  textFont(font);
  text(score,115,50);
}
