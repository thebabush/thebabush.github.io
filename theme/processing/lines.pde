final int FPS = 30;
final float RESTITUTION = 0.02;
final float WAVE_SPEED = 0.6;
final float STEP_LENGTH = 3.0; 
final float POSITION_RANDOMNESS = 5.0;
final float VELOCITY_RANDOMNESS = 1.0;
final float SPACING_WIDTH = 20;

final float COLOR_SPEED = 0.03;
final float COLOR_LPF_ALPHA = 0.6;

PVector gridPos[][];
PVector gridVel[][];
PVector gridAcc[][];

float aspectRatio;
float spacingW;
float spacingH;
int gridW;
int gridH;


PGraphics buffer;

boolean animating = false;
boolean firstAnimation;

void animate(flag) {
  animating = flag;
}

void setup() {
  buffer = createGraphics(width, height);
  firstAnimation = true;
  
  //smooth(4);
  frameRate(FPS);
  
  //strokeWeight(ceil(width / 640.0));
  strokeWeight(1);
  
  aspectRatio = width / float(height);
  spacingW = SPACING_WIDTH;
  spacingH = height / round(float(height) / spacingW);
  
  gridW = ceil(width / spacingW) + 1;
  gridH = ceil(height / spacingH) + 1;
  gridPos = new PVector[gridW][gridH];
  gridVel = new PVector[gridW][gridH];
  gridAcc = new PVector[gridW][gridH];
  for (int i = 0; i < gridW; i++) {
    for (int j = 0; j < gridH; j++) {
      gridPos[i][j] = new PVector(i * spacingW + random(-POSITION_RANDOMNESS, POSITION_RANDOMNESS), j * spacingH + random(-POSITION_RANDOMNESS, POSITION_RANDOMNESS));
      gridVel[i][j] = new PVector(random(-VELOCITY_RANDOMNESS, VELOCITY_RANDOMNESS), random(-VELOCITY_RANDOMNESS, VELOCITY_RANDOMNESS));
      gridAcc[i][j] = new PVector(0, 0);
    }
  }
  
  buffer.beginDraw();
  buffer.colorMode(HSB, 1.0);
  buffer.background(0);
  buffer.endDraw();
  
  background(0);
}

float hh = random(1);
float ss = random(0.9, 1);

void draw() {
  if (!firstAnimation && !animating)
    return;

  firstAnimation = false;
  update();
  
  buffer.beginDraw();
  buffer.background(0, 0.5);
  //buffer.background(0);
  
  hh = (1.0 - COLOR_LPF_ALPHA) * hh + COLOR_LPF_ALPHA * (hh + random(-COLOR_SPEED, COLOR_SPEED));
  hh %= 1.0; hh += 1.0; hh %= 1.0;
  ss = (1.0 - COLOR_LPF_ALPHA) * ss + COLOR_LPF_ALPHA * (ss + random(-COLOR_SPEED, COLOR_SPEED));
  norm(ss, 0.0, 1.0);
  
  for (int i = 0; i < gridW - 1; i++) {
    for (int j = 0; j < gridH - 1; j++) {
      float x = gridPos[i][j].x;
      float y = gridPos[i][j].y;
      
      if (j > 0) {
        buffer.stroke(hh, ss, calcColor(i, j, i + 1, j));
        buffer.line(x, y, gridPos[i + 1][j    ].x, gridPos[i + 1][j    ].y);
      }
      
      if (i > 0) {
        buffer.stroke(hh, ss, calcColor(i, j, i, j + 1));
        buffer.line(x, y, gridPos[i    ][j + 1].x, gridPos[i    ][j + 1].y);
      }
    }
  }
  buffer.endDraw();
  
  image(buffer, 0, 0);
}

float calcColor(int i1, int j1, int i2, int j2) {
  float dx = abs(gridPos[i1][j1].x - gridPos[i2][j2].x);
  float dy = abs(gridPos[i1][j1].y - gridPos[i2][j2].y);
  return 1.0 / min(dx, dy) / 2.5;
}

void update() {
  float dt = STEP_LENGTH / FPS;
  
  for (int i = 1; i < gridW - 1; i++) {
    for (int j = 1; j < gridH - 1; j++) {
      gridAcc[i][j].x = - RESTITUTION * (gridPos[i][j].x - i * spacingW);
      gridAcc[i][j].y = - RESTITUTION * (gridPos[i][j].y - j * spacingH);
    }
  }
  for (int i = 1; i < gridW - 1; i++) {
    for (int j = 1; j < gridH - 1; j++) {
      gridVel[i][j].x += gridAcc[i][j].x * dt;
      gridVel[i][j].y += gridAcc[i][j].y * dt;
    }
  }
  for (int i = 1; i < gridW - 1; i++) {
    for (int j = 1; j < gridH - 1; j++) {
      gridPos[i][j].x += gridVel[i][j].x * dt;
      gridPos[i][j].y += gridVel[i][j].y * dt;
    }
  }
}

