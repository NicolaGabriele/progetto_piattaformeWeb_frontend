
class Constants {

  static final String MESSAGE_CONNECTION_ERROR = "Errore di connessione";
  static final String CLIENT_ID = "clinica";
  static final String CLIENT_SECRET = "hYDskia9lgR6Mq8fBR5aSadrRfpCfXc8";
  static final String ADDRESS_STORE_SERVER = "localhost:9000";
  static final String ADDRESS_AUTHENTICATION_SERVER = "localhost:8080";
  static final String REALM = "clinica-flutter";
  static final String REQUEST_LOGIN = "/auth/realms/" + REALM + "/protocol/openid-connect/token";
  static final String REQUEST_LOGOUT = "/auth/realms/" + REALM + "/protocol/openid-connect/logout";
  static final String RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS = "ERROR_MAIL_USER_ALREADY_EXISTS";

}