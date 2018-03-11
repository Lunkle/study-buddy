TextField[] textBoxes = {};
TextField currentFocus;
float k = 2*PI/(530 * frameRate/100);
int padding = 3;

class TextField{
    int number;
    PVector position;
    int boxWidth;
    int boxHeight;
    
    int setFocusedFrame;
    String text = "";
    
    public TextField(int middleX, int middleY, int boxWidth, int boxHeight){
        position = new PVector(middleX - boxWidth/2, middleY - boxHeight/2);
        this.boxWidth = boxWidth;
        this.boxHeight = boxHeight;
        number = textBoxes.length;
        textBoxes = (TextField[]) append(textBoxes, this);
    }
    
    public void displayTextField(){
        noStroke();
        //Draw text field.
        fill(0);
        rect(position.x, position.y, boxWidth, boxHeight);
        fill(255);
        rect(position.x + padding, position.y + padding, boxWidth - padding - padding, boxHeight - padding - padding);
        //Draw text.
        fill(0);
        textAlign(LEFT);
        textSize(boxHeight - 20);
        text(" " + text, position.x, position.y + boxHeight - padding - 10);
        //Draw text cursor if focused.
        stroke(0);
        if(currentFocus != null){
            if(currentFocus.equals(this) && sin(k *(frameCount - setFocusedFrame)) >= 0){
                int xValue = parseInt(position.x + textWidth(" " + text));
                line(xValue, position.y + padding + 5, xValue, position.y + boxHeight - padding - 5);
            }
        }
    }
    
    void clearAllTextFields(){
        textBoxes = new TextField[0];
    }
}