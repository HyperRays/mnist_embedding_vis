import processing.opengl.*;
 
 
color defaultColor = #66bcd9;
ArrayList<Embed> embeds = new ArrayList<Embed>();
int dim = 250;

PGraphics box;
PGraphics points;
PGraphics overlay;


String path = "./data/embedding_examples6.csv";
int threshold = 60000;
color[] colorPalette = {#76cf45, #00c556, #00ba6f, #00ac8b, #009da8, #008cc4, #007bd9, #0068e4, #0052e3, #0037d3};

class Embed{
  int target;
  PVector embedding;
  
  Embed (int t, PVector e){
    target = t;
    embedding = e;
  }
  
  color mapColor() {
    return colorPalette[this.target];
  }
}

Table table;
PVector[] avg = new PVector[10];

void setup() {
  
  size(500,500,OPENGL);
  points = createGraphics(width, height, P3D);
  box = createGraphics(width, height, P3D);
  overlay = createGraphics(width, height, P3D);
  dim = min(width,height)/2;
  
  box.smooth(8);
  
  box.beginDraw();
  box.noFill();
  box.strokeWeight(3);
  box.stroke(defaultColor);
  box.endDraw();

  
  int[] count = new int[10];

  table = loadTable(path, "header");

  println(table.getRowCount() + " total rows in table");
  int i = 0;
  for (TableRow row : table.rows()) {
     
    int target = row.getInt("0");
    
    PVector embedding = new PVector(row.getFloat("1"),row.getFloat("2"),row.getFloat("3"));
    
    Embed embed = new Embed(target, embedding);
    
    embeds.add(embed);
    i ++;
    if(i > threshold){
       break; 
    }
  }
  
  for (int n = 0; n < 10; n++) {
    avg[n] = new PVector(0,0,0);
    count[n] = 0;
  }
  
  for (Embed embed: embeds) {
    avg[embed.target].add(embed.embedding);
    count[embed.target] += 1;
  }
  
  for (int n = 0; n < 10; n++) {
    avg[n].div(count[n]);
  }
  

}

void draw() {
  
  drawBox();
  image(box, 0, 0);
  
  drawPoints();
  image(points, 0, 0);
  
  drawOverlay();
  image(overlay, 0, 0);
  

}

void setTransform(PGraphics gr){
  gr.translate(width/2,height/2);
  gr.scale(1,-1,1); // so Y is up, which makes more sense in plotting
  gr.rotateY((float(mouseX)/float(width))*PI*1.75);
  
  gr.rotateZ((float(mouseY)/float(height))*PI*1.75);
}


void drawPoints() {
    points.beginDraw();
    points.clear();
    setTransform(points);
    points.translate(-dim/2,-dim/2,-dim/2);
    points.strokeWeight(2);
    for (Embed embed: embeds) {
      PVector v = embed.embedding.copy();
      v.mult(dim);
      points.stroke(embed.mapColor());
      points.point(v.x,v.y,v.z);
    }
    points.endDraw();
}

void drawBox() {
  box.beginDraw();
  box.background(0);
  setTransform(box);
  box.box(dim);
  box.endDraw();
}

void drawOverlay() {
  overlay.beginDraw();
  overlay.clear();
  setTransform(overlay);
  overlay.translate(-dim/2,-dim/2,-dim/2);
  overlay.stroke(255);
  overlay.strokeWeight(10);
  for (int n = 0; n < 10; n++) {
    PVector v = avg[n].copy();
    v.mult(dim);
    overlay.point(v.x,v.y,v.z);
    overlay.fill(255);
    overlay.text(str(n),v.x,v.y, v.z);
  }
  overlay.endDraw();
}
