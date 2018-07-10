package codeu.model.data;

import codeu.model.store.basic.UserStore;
import java.time.Instant;
import java.util.UUID;
import org.mindrot.jbcrypt.BCrypt;

/** Class representing a Bot. */
public class Bot extends User {
  
  /**
  * Constructs a new Bot.
  */
  public Bot() {
    super(
        UUID.randomUUID(), 
        "NemoBot", 
        BCrypt.hashpw("NemoBotPassword2018", BCrypt.gensalt()), 
        Instant.now());
    setAboutMe("I'm NemoBot. Want to talk to me? Simply @ mention me in any conversation!");
    setIsAdmin(true);
    setLastSeenNotifications(null);
    UserStore.getInstance().addUser(this);
  }

  /*
  * Scans a message to identify keywords.
  */
  public String parseMessage(String messageContent) {
    String keyword;
    // TODO find keyword

    // If and only if no keyword was found.
    keyword = "N/A";

    return getMessageContent(keyword);
  }

  /*
  * Creates a Message object based on the keyword.
  */
  private String getMessageContent(String keyword) {
    if (!keyword.equals("N/A")) {
      // TODO get appropriate response
    }

    return "I'm sorry. I didn't understand that.";
  }
}