//Variables
//Input -- Llibreria controlP5
//import controlP5.*;
//ControlP5 cp5;
//String textValue = "";

//player
float pjX;
float pjY;

//pnjs (aliats)
float[] pnjX = new float [2];
float[] pnjY = new float [2];
float[] pnjS = new float [2];
int[] dist = new int [2];
int[] hp = new int[2];
PVector[] pnjV = new PVector [2];

//power ups
float[] powUpX = new float [3];
float[] powUpY = new float [3];
boolean[] powUpGet = new boolean [3];

int powUpGot; //int que cuenta los power ups conseguidos para saber cuando spawnear el portal

boolean powers; //bool para spawnear los powerups/downs

//power downs
float[] powDownX = new float [3];
float[] powDownY = new float [3];
boolean[] powDownGet = new boolean [3];

//PNJS N (enemics)
int n = 5;
float[] x_pnj = new float[n]; //5 momentani, s'ha de fer lo de input nº enemics
float[] y_pnj = new float[n]; //5 momentani, s'ha de fer lo de input nº enemics
float[] alfa = new float[n]; //5 momentani, s'ha de fer lo de input nº enemics

int counterNSpawning = second(), startN = second();
int m = 0;




//Set-Up
void setup()
{
  //pantalla
  size (800, 800);
  
  //asegurarnos de que cuadrados/rectangulos aparecen al centro de las coordenadas
  rectMode(CENTER);
  
  //pnjs stats
  pnjS[0] = 5;
  //0 porque espera a ser recogido
  pnjS[1] = 0;
  dist[0] = 125;
  dist[1] = 75;
  hp[0] = 5;
  hp[0] = 5;
  
  //pnjs spawnpoint
  pnjX[0] = width/2;
  pnjY[1] = 0;
  pnjX[1] = random(750);
  pnjY[1] = random(750);
  
  //powerUps spawnpoint
  for (int i = 0; i < 3; i++)
  {
    powUpX[i] = random(50, 750);
    powUpY[i] = random(50, 750);
  }
  //powerDowns spawnpoint
  for (int i = 0; i < 3; i++)
  {
    powDownX[i] = random(50, 750);
    powDownY[i] = random(50, 750);
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
  
  
  for (int i = 0; i < n; i++)
  {
    if (i < n/2)
    {
      alfa[i] = random(-0.0001f,-0.0002f); 
    }
    else
    {
      alfa[i] = random(0.008f,0.002f); 
    }
  }  
}




//Draw
void draw()
{
  
  background(0, 0, 0);
  
  pjX = mouseX;
  pjY = mouseY;
  
  //check if pnj2 picked
  if (checkDist(pjX, pjY, pnjX[1], pnjY[1]) < 50) //check sense .mag
  {
    //ahora te sigue
    pnjS[1] = 3;
    powers = true;
  }
  
  
  //pnjs calc
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
  
  
  //RENDERS
  
  //pj
  fill(0, 255, 0);
  ellipse(pjX, pjY, width/20, height/20);
  
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
     fill(255,0,0);
     ellipse(x_pnj[i],y_pnj[i], width/25, height/25);
   }
  // p(alfa) = PNJ + alfa * PJ --> p(alfa) = (1-alfa) * PNJ + alfa * PJ
  for(int i = 0; i < m/2; i++)
  {
    x_pnj[i] = (1.0 - alfa[i]) * x_pnj[i] + alfa[i] * pjX;
    y_pnj[i] = (1.0 - alfa[i]) * y_pnj[i] + alfa[i] * pjY; 
  }
    for(int i = m/2; i < m/4 + m/2; i++)
  {
    x_pnj[i] = (1.0 - alfa[i]) * x_pnj[i] + alfa[i] * pnjX[0];
    y_pnj[i] = (1.0 - alfa[i]) * y_pnj[i] + alfa[i] * pnjY[0]; 
  }
    for(int i = m/2+m/4; i < m; i++)
  {
    x_pnj[i] = (1.0 - alfa[i]) * x_pnj[i] + alfa[i] * pnjX[1];
    y_pnj[i] = (1.0 - alfa[i]) * y_pnj[i] + alfa[i] * pnjY[1]; 
  }
 }
 
  EnemySpawner();
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
  
  println(checkDist(pjX, pjY, powUpX[0], powUpY[0]));
  println(pjX, pjY);
  println(powUpX[0], powUpY[0]);
  
  //powerUps
  for (int i = 0; i < 3; i++)
  {
    if (!powUpGet[i])
    {
      if (checkDist(pjX, pjY, powUpX[i], powUpY[i]) < 30)
      {
        powUpGet[i] = true;
      }
    }
  }
  
  //powerDowns
  for (int i = 0; i < 3; i++)
  {
    if (!powDownGet[i])
    {
      if (checkDist(pjX, pjY, powDownX[i], powDownY[i]) < 30)
      {
        powDownGet[i] = true;
      }
    }
  }
  
}

float checkDist(float x1, float y1, float x2, float y2)
{
  return (new PVector (x1 - x2, y1 - y2).mag()); 
}
