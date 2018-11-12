/*
 Description: This program displays files that do not match a given criteria
 Author: Azan Muhammad and Emily Wang
 Date of last edit: May 28, 2017
 */

boolean checkFiles = true, firstCharacterCheck, nameLengthCheck, extensionCriteriaCheck, fileSizeCheck, unallowableCharCheck;
float maxSizeOfFile, moveBall, scrollingAmount, upScroll, downScroll;
String [] meetsExtensionCriterias, firstCharacterCriteria, nameLengthCriteria;
String  charactersInFileName, improperFilesToBeFixed;
PImage imgCharacter, imgLogo;
ArrayList <String> displayName;
int portion = 1;

void settings() {
  size(600, 600);
}

void setup() {
  background(255);

  PFont avenirFont; //font 
  avenirFont=loadFont("Avenir-Black-48.vlw");
  textFont(avenirFont);
  displayName = new ArrayList<String>(); //arraylist for file names  displays

  moveBall = 0;
  imgCharacter = loadImage("character.jpg"); //game character 
  imgLogo = loadImage("logo.png"); //File peg logo

  //Loads the instructions file
  String [] instructions = loadStrings("instructions.txt");
  //Defines criteria
  nameLengthCriteria = instructions[0].split(".");
  meetsExtensionCriterias = instructions[1].split(" ");
  firstCharacterCriteria = instructions[3].split("");
  maxSizeOfFile = float(instructions[4]);

  //Loads file with all file names
  String [] file = loadStrings("dataFile_sample.txt");

  //checks each criteria by going down the list of file names 
  for (int i = 0; i < file.length; i++) {

    String [] lineInFile=file[i].split("\\\\"); //isolates the file name and extension

    //Checks if first character is acceptable
    char [] firstCharCriteria = instructions[3].toCharArray(); 
    char [] firstChar = lineInFile[5].toCharArray();
    {
      for (int y = 0; y < firstCharCriteria.length; y++) {
        if (firstChar[y]!=firstCharCriteria[y]  ) {
          firstCharacterCheck=true;
        } else {
          firstCharacterCheck=false;
        }
      }
    }

    //checks if name length is acceptable
    String name=split(lineInFile[5], ".")[0]; //isolates just file name
    String extension=split(lineInFile[5], ".")[1]; //isolates just file extension
    char [] nameLength = name.toCharArray(); //turns into char arrays
    char [] extLength = extension.toCharArray();
    float nameLengthCriteria = float(split(instructions[0], ".")[0]); //defines the criteria of max name length
    float extLengthCriteria = float(split(instructions[0], ".")[1]);  //defines the criteria of max extension length

    //compares the file name against criteria
    if (nameLengthCriteria>=(nameLength.length)&& extLengthCriteria>=(extLength.length)) {
      nameLengthCheck=true;
    } else {
      nameLengthCheck=false;
    }
    //checks if the extension is accepted
    String [] meetsExtensionCriteriasFile = split(file[i], ".");
    //checks through the list of accepted criteria names
    for (int j = 0; j < meetsExtensionCriterias.length; j++) {

      //compares the file name against criteria
      if (meetsExtensionCriteriasFile[1].equals(meetsExtensionCriterias[j])) {
        extensionCriteriaCheck = true;
        break;
      }
    }

    //checks the file size
    String [] fileLines = file[i].split("\\\\");
    float sizeOfFile = float(fileLines [0]);
    if (sizeOfFile > maxSizeOfFile) {
      fileSizeCheck = true;
    } else {
      fileSizeCheck=false;
    }

    //checks for any unallowable Characters
    charactersInFileName = split(fileLines [5], ".")[0];
    char [] charactersInFileNameChar = charactersInFileName.toCharArray();
    char [] unallowableCharactersCriteriaChars = instructions[2].toCharArray();
    for (int h = 0; h < charactersInFileNameChar.length; h++) { //checks each character in file name
      for (int j = 0; j < unallowableCharactersCriteriaChars.length; j++) { //checks each unacceptabed character in criteria

        if (charactersInFileNameChar[h] == unallowableCharactersCriteriaChars[j]) {
          unallowableCharCheck = true;
        }
      }
    }

    //checks the booleans from criteria for unaccepted file names and adds to string list array to be displayed
    if (unallowableCharCheck == true || !extensionCriteriaCheck || fileSizeCheck || nameLengthCheck==false ||  firstCharacterCheck==true) {
      displayName.add(charactersInFileName);
    }
  }
}



void draw() {

  //starting screen
  if (checkFiles == true) {
    screenBackground();
    checkResultsButton();
    loadingSign();

    //2nd screen where files are displayed
  } else {
    background(255);
    displayImproperFiles();
    screenBackground2();
  }
}

void screenBackground() {
  noStroke();
  fill(#318AC4);
  rect(-1, -1, 601, 150);
  fill(2355);
  textSize(90);
  fill(255);
  text("File Peg", 5, 100);
  image(imgCharacter, 15, 180); //Character from the game created by Allied Games
  image(imgLogo, 450, 15); //file peg logo
}
void checkResultsButton() {
  //button to switch over to second screen
  stroke(#BCBCBC);
  strokeWeight(20);
  line(-20, 150, 620, 150);
  strokeWeight(5);
  fill(255);
  rect(10, 560, 175, 30);
  textSize(25);
  fill(#318AC4);
  text("Check Results", 15, 585);
}

void mousePressed() {
  //switches to screen 2
  if (mouseY < 590 && mouseY > 560 && mouseX > 10 && mouseX < 185) { //if the mouse is clicked within a specific area
    if (mouseButton == LEFT) {
      checkFiles = false ; //switches to next screen
    }
  }
}

void loadingSign() {
  textSize(40);
  fill(#318AC4);
  text("Analyzing", 320, 250);
  text("Files...", 360, 300);
  //draws spinning circles
  fill(255, 25);
  noStroke();
  rect(315, 365, 210, 210); //allowes for the trailing effect
  moveBall++; 
  noFill(); //no lines will be formed extending from the center of the arcs to the tips
  stroke(#318AC4);
  strokeWeight(25); //thickness of the arc
  for (int i = 0; i < 360; i +=72) { 
    arc (420, 470, 119, 119, radians(i+moveBall), radians(i+1+moveBall)); // the moving circles
  }
}

void screenBackground2() {
  //header
  fill(#318AC4);
  rect(0, 0, 600, 40);
  textSize(40);
  fill(255);
  text("Files To Be Fixed", 150, 40);
  //User help
  textSize(12); //text size of instruction at the bottom right
  fill(#318AC4); //text colour blue
  text ("*Scroll to view all files if necessary*", 400, 590);
}

void displayImproperFiles() {
  //displays the improper text files
  fill(0); //makes text colour black
  textSize(15); //size of the words that display the file names
  for (int i=0; i<displayName.size(); i++) {
    String name=displayName.get(i);
    text(name, 10, (upScroll-downScroll)+(i*18.75+70) ); //displays the incorrect file names
}
  noLoop();
  if (upScroll-downScroll > 0) { //prevents the user from scrolling up past the first file name
    upScroll=downScroll;
  }
   if (downScroll-upScroll > displayName.size()*18.75-543.75) { //prevents the user from scrolling down past the last file name
    downScroll=displayName.size()*18.75+upScroll-543.75;
   }
  }




void mouseWheel(MouseEvent event) {
  loop();
  scrollingAmount = event.getCount();

  if (scrollingAmount<0) {
    upScroll+=18.75;  //scrolls up in increments of 18.75
  }
  if (scrollingAmount>0) {
    downScroll+=18.75; //scrolls down in increments of 18.75
  }
}