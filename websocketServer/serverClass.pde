  //websocket server
import org.java_websocket.handshake.*;
import org.java_websocket.server.*;
import org.java_websocket.exceptions.*;
import org.java_websocket.*;
import org.java_websocket.drafts.*;
import java.net.URI;

import java.net.InetSocketAddress;
import java.net.UnknownHostException;
//import java.util.Collection;

class Server extends WebSocketServer {
  Server(int port) throws UnknownHostException {
    super(new InetSocketAddress(port));
  }

  Server( InetSocketAddress address ) {
    super( address );
  }

  void onOpen( WebSocket conn, ClientHandshake handshake) {
    System.out.println( conn.getRemoteSocketAddress().getAddress().getHostAddress() + " entered the room!" );
    //color col = randomColor();
    //addAgent(conn, col);
    addProtoAgent(conn);
    //conn.send(hex(col, 6));
  }

  void onClose( WebSocket conn, int code, String reason, boolean remote ) {
    System.out.println( conn.getRemoteSocketAddress().getAddress().getHostAddress() + " left the room!" );
    for (UserAgent a: agents) {
      if (a.id == conn) {
        a.remove = true;
      }
    }
  }

  void onMessage( WebSocket conn, String message ) {
    //println( conn + ": " + message + ": " + millis() );
    try {
      JSONObject json = JSONObject.parse(message);
      for (UserAgent a: agents) {
        if (a.id == conn) {
          a.updateInput(json);
        }
      }
    }
    catch(Error e) {
    }
  }

  void onError( WebSocket conn, Exception ex ) {
    ex.printStackTrace();
    if ( conn != null ) {
    }
  }

}

