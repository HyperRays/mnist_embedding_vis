import processing.opengl.*;
 
ArrayList<Embed> embeds = new ArrayList<Embed>();
int dim = 250;

String path = "./data/embedding_examples6.csv";
int threshold = 50000;

class Embed{
  int target;
  PVector embedding;
  
  Embed (int t, PVector e){
    target = t;
    embedding = e;
  }
}

Table table;

void setup() {
  
  size(500,500,OPENGL);

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
    //print("target: " + embed.target + " " + "embedding: " + embed.embedding + "\n");
  }

}

void draw() {
  background(0);
  translate(width/2,height/2);
  scale(1,-1,1); // so Y is up, which makes more sense in plotting
  rotateY((float(mouseX)/float(width))*PI*1.75);
  
  rotateZ((float(mouseY)/float(height))*PI*1.75);
  
  dim = min(width,height)/2;
  
  noFill();
  strokeWeight(1);
  box(dim);

  translate(-dim/2,-dim/2,-dim/2);
  for (Embed embed: embeds) {
    PVector v = embed.embedding.copy();
    v.mult(dim);
    float n = ((float(embed.target)+1.) / 10.0)*50.;
    stroke(v.x+n,v.y+n,v.z+n);
    strokeWeight(5);
    point(v.x,v.y,v.z);
  }
}
