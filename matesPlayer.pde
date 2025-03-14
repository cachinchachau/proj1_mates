//vars

//player
float pjX;
float pjY;

//pnjs
float[] pnjX = new float [2];
float[] pnjY = new float [2];
float[] pnjS = new float [2];
int[] dist = new int [2];
PVector[] pnjV = new PVector [2];

//start
void setup()
{
  //pantalla
  size (800, 800);
  
  //pnjs stats
  pnjS[0] = 5;
  //0 porque espera a ser recogido
  pnjS[1] = 0;
  dist[0] = 125;
  dist[1] = 75;
  
  //pnjs spawnpoint
  pnjX[0] = width/2;
  pnjY[1] = 0;
  pnjX[1] = random(750);
  pnjY[1] = random(750);
  
}

//udpate
void draw()
{
  
  background(0, 0, 0);
  
  pjX = mouseX;
  pjY = mouseY;
  
  //PJ
  fill(0, 255, 0);
  ellipse(pjX, pjY, width/20, height/20);
  
  
  //PNJS
  
  fill(0, 0, 255);
  
  //check if pnj2 picked
  if (new PVector (pjX - pnjX[1], pjY - pnjY[1]).mag() < 50)
  {
    //ahora te sigue
    pnjS[1] = 3;
  }
  
  
  //calc
  for (int i = 0; i < 2; i++)
  {
    if (new PVector (pjX - pnjX[i], pjY - pnjY[i]).mag() > dist[i])
    {
      pnjV[i] = new PVector (pjX - pnjX[i], pjY - pnjY[i]);
      pnjV[i] = pnjV[i].normalize().setMag(pnjS[i]);
      pnjX[i] += pnjV[i].x;
      pnjY[i] += pnjV[i].y;
    }
    
  }
  
  //render
  for (int i = 0; i < 2; i++)
  {
    ellipse(pnjX[i], pnjY[i], width/20, height/20); 
  }
}
