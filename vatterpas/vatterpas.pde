import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;

Context context;
SensorManager manager;
Sensor sensor;
AccelerometerListener listener;
float ax, ay, az;

float ballX, ballY;

void setup() {
  fullScreen();

  context = getActivity();
  manager = (SensorManager)context.getSystemService(Context.SENSOR_SERVICE);
  sensor = manager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
  listener = new AccelerometerListener();
  manager.registerListener(listener, sensor, SensorManager.SENSOR_DELAY_GAME);

  textFont(createFont("SansSerif", 30 * displayDensity));
}

void draw() {
  background(0);
  
  final float tiltVectorLength = sq(ax * 50) + sq(ay * 50);
  
  if (tiltVectorLength <= 20*20) {
    background(0, 255, 0);
  }

  fill(255);
  textAlign(LEFT, TOP);
  text("X: " + ax + "\nY: " + ay + "\nZ: " + az, 0, 0, width, height);

  final int centerX = width/2;
  final int centerY = height/2;

  fill(80);
  circle(centerX, centerY, 100);

  final float goalX = centerX + ax * 50;
  final float goalY = centerY - ay * 50;
  
  final float lerpAmount = 0.1; //Styrer hvor hurtigt bolden bevæger sig mod målet
  ballX = lerp(ballX, goalX, lerpAmount);
  ballY = lerp(ballY, goalY, lerpAmount);
  
  fill(255, 0, 0);
  circle(goalX, goalY, 40);
  fill(255);
  circle(ballX, ballY, 80);
  
  final PVector upVector = new PVector(0, 0, 1);
  final PVector phoneVector = new PVector(ax, ay, az);
  final int angle = (int) degrees(PVector.angleBetween(upVector, phoneVector));
  fill(0);
  textAlign(CENTER, CENTER);
  text(angle, centerX, centerY);
}

class AccelerometerListener implements SensorEventListener {
  public void onSensorChanged(SensorEvent event) {
    ax = event.values[0];
    ay = event.values[1];
    az = event.values[2];
  }
  public void onAccuracyChanged(Sensor sensor, int accuracy) {
  }
}
