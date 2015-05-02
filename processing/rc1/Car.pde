/*

*/

public class Car {
  
  public int step_duration = 250; // milliseconds
  public String last_action;
  public String actual_action;
  public String mode = "drive"; // step or drive

  public ArrayList<String> actions = new ArrayList<String>();
  
  public GpioPinDigitalOutput motorLFW;
  public GpioPinDigitalOutput motorLBW;
  public GpioPinDigitalOutput motorRFW;
  public GpioPinDigitalOutput motorRBW;
  
  public Car(){
    
    this.motorRBW = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_00, PinState.LOW);
    this.motorRFW = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_01, PinState.LOW);
    this.motorLBW = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_03, PinState.LOW);
    this.motorLFW = gpio.provisionDigitalOutputPin(RaspiPin.GPIO_04, PinState.LOW);
  }
  
  public void stopMovement(String action){

    this.actions.remove(action);

    if(action.equals("rotate-left")) {
      if(this.actions.contains("move-forward")){
        this.motorLFW.high();
        this.setAllOff();
        return;
      }
      if(this.actions.contains("move-backward") ) {
        this.motorLBW.high();
        this.setAllOff();
        return;
      }
      
    }
    
    if(action.equals("rotate-right")){
      if(this.actions.contains("move-forward")) {
        this.motorRFW.high();
        this.setAllOff();
        return;
      }
      if(this.actions.contains("move-backward")) {
        this.motorRBW.high();
        this.setAllOff();
        return;
      }
    }
    
    if(action.equals("move-forward")) {
      if(this.actions.contains("rotate-left")) {
        this.motorLFW.low();
        this.motorLBW.high();
        this.setAllOff();
        return;
      }
      if(this.actions.contains("rotate-right")) {
        this.motorRFW.low();
        this.motorRBW.high();
        this.setAllOff();
        return;
      }
    }
    
    if(action.equals("move-backward")) {
      if(this.actions.contains("rotate-left")) {
        this.motorLBW.low();
        this.motorLFW.high();
        this.setAllOff();
        return;
      }
      if(this.actions.contains("rotate-right")) {
        this.motorRBW.low();
        this.motorRFW.high();
        this.setAllOff();
        return;
      }
    }

    this.motorLFW.low();
    this.motorRFW.low();
    this.motorLBW.low();
    this.motorRBW.low();
    
    this.actions.remove(action);
    println("stop: "+action);
  }
  
  public void moveForward(){
    this.motorLFW.high();
    this.motorRFW.high();
    this.setAllOff();
  }
  
  public void moveBackward(){
    this.motorLBW.high();
    this.motorRBW.high();
    this.setAllOff();
  }
  
  public void rotateLeft(){
    String fw = this.motorLFW.getState()+""+this.motorRFW.getState();
    String bw = this.motorLBW.getState()+""+this.motorRBW.getState();
    
    if(fw.equals("HIGHHIGH")){
      this.motorLFW.low();
      this.setAllOff();
      return;
    }
    
    if(bw.equals("HIGHHIGH")) {
      this.motorLBW.low();
      this.setAllOff();
      return;
    }
    
    this.motorLBW.high();
    this.motorRFW.high();
    this.setAllOff();

  }
  
  public void rotateRight(){
    String fw = this.motorLFW.getState()+""+this.motorRFW.getState();
    String bw = this.motorLBW.getState()+""+this.motorRBW.getState();
    
    if(fw.equals("HIGHHIGH")){
      this.motorRFW.low();
      this.setAllOff();
      return;
    }
    
    if(bw.equals("HIGHHIGH")) {
      this.motorRBW.low();
      this.setAllOff();
      return;
    }
    
    this.motorLFW.high();
    this.motorRBW.high();
    this.setAllOff();
  }
  
  public void turnForwardLeft(){
    this.motorRFW.high();
    this.setAllOff();
  }
  
  public void turnForwardRight(){
    this.motorLFW.high();
    this.setAllOff();
  }
  
   public void turnBackwardLeft(){
     this.motorRBW.high();
     this.setAllOff();
   }
   
   public void turnBackwardRight(){
     this.motorLBW.high();
     this.setAllOff();
   }
   
   public void setAllOff() {
     if(this.mode.equals("step")){
       delay(this.step_duration);
       this.stopMovement("all");
     }  
   }
  
}
