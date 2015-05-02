/*
    Command Server for Websocket HTML-Client
*/
public class CommandServer extends WebSocketServer {
  
  public int openConnections;
  
  public CommandServer( int port ) {
    super( new InetSocketAddress( port ) );
  }
  public CommandServer( InetSocketAddress address ) {
    super( address );
  }

  @Override
  public void onOpen( WebSocket conn, ClientHandshake handshake ) {
    this.openConnections++;
    System.out.println( "CommandServer: "+conn.getRemoteSocketAddress().getAddress().getHostAddress() + " connected!" );
  }

  @Override
    public void onClose( WebSocket conn, int code, String reason, boolean remote ) {
    this.openConnections--;
    System.out.println( "CommandServer: "+conn + " has left" );
  }

  @Override
    public void onMessage( WebSocket conn, String message ) {
      System.out.println("Command Server: "+conn + ": " + message );
      this.processMessage(message, conn);
  }

  @Override
    public void onError( WebSocket conn, Exception ex ) {
    ex.printStackTrace();
    if ( conn != null ) {
      // some errors like port binding failed may not be assignable to a specific websocket
    }
  }
  
  /*
  *
  */
  public void processMessage(String message, WebSocket conn){
    JSONObject m = JSONObject.parse( message );
    
    if (m.hasKey("step-duration")) {
      car.mode = "step";
      car.step_duration = m.getInt("step-duration");;
    }
    
    if (m.hasKey("action")) {
      String action = m.getString("action");   
      
      car.actions.add(action);
      
      if(action.equals("move-forward"))
        car.moveForward();
        
      if(action.equals("move-backward"))
        car.moveBackward();
        
      if(action.equals("rotate-left"))
        car.rotateLeft();
      
      if(action.equals("rotate-right"))
        car.rotateRight();
      
      if(action.equals("turn-forward-left"))
        car.turnForwardLeft();
      
      if(action.equals("turn-forward-right"))
        car.turnForwardRight();
      
      if(action.equals("turn-backward-left"))
        car.turnBackwardLeft();
      
      if(action.equals("turn-backward-right"))
        car.turnBackwardRight();
    }
    
    //
    if (m.hasKey("stop")) {
      String action = m.getString("stop");
      car.stopMovement(action);       
 
    }
    
  }

  /*
  *
  */
  public void sendToAll( String text ) {
    Collection<WebSocket> con = connections();
    synchronized ( con ) {
      for ( WebSocket ws : con ) {
        ws.send( text );
      }
    }
  }

}
