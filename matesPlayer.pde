//vars

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

//start
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
  
}

//udpate
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
  fill(255, 255, 255);
  for (int i = 0; i < 3 && powers ; i++)
  {
    if (!powDownGet[i])
    {
      square(powDownX[i], powDownY[i], 20);
    }
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
