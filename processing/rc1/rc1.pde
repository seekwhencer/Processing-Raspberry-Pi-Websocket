// napplet, multiple files
import napplet.*;

// spacebrew
//import spacebrew.*;

// pi4j
import com.pi4j.io.gpio.GpioController;
import com.pi4j.io.gpio.GpioFactory;
import com.pi4j.io.gpio.GpioPinDigitalInput;
import com.pi4j.io.gpio.GpioPinDigitalOutput;
import com.pi4j.io.gpio.PinPullResistance;
import com.pi4j.io.gpio.RaspiPin;
import com.pi4j.io.gpio.PinState;


//
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.lang.reflect.Method;

import org.java_websocket.client.WebSocketClient;
import org.java_websocket.drafts.Draft;
import org.java_websocket.drafts.Draft_10;
import org.java_websocket.drafts.Draft_17;
import org.java_websocket.framing.Framedata;
import org.java_websocket.handshake.ServerHandshake;

import org.java_websocket.exceptions.InvalidHandshakeException;
import org.java_websocket.handshake.ClientHandshake;
import org.java_websocket.handshake.ClientHandshakeBuilder;

// websocket server
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetSocketAddress;
import java.net.UnknownHostException;
import java.util.Collection;

import org.java_websocket.WebSocket;
import org.java_websocket.WebSocketImpl;
import org.java_websocket.framing.Framedata;
import org.java_websocket.handshake.ClientHandshake;
import org.java_websocket.server.WebSocketServer;

int WIDTH = 1;
int HEIGHT = 1;

GpioController gpio;
CommandServer s;
Car car;

String commandServerPort = "7777";

void setup() {
  println("run");
  size(10,10);
  
  //init Websocket Command Server
  new ServerThread().start();
  gpio = GpioFactory.getInstance();
  car = new Car();
  
  
  //gpio.shutdown();
  //println("run end");
  //exit(); 
}


@ Override boolean displayable() {
  return false;
}
