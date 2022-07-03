import 'dart:async';
import 'dart:convert';

import 'package:frontend_progetto_piattaforme/models/Objects/Paziente.dart';
import 'package:frontend_progetto_piattaforme/models/Objects/Prenotazione.dart';
import 'package:frontend_progetto_piattaforme/models/manager/RestManager.dart';
import 'package:frontend_progetto_piattaforme/models/AuthenticationData.dart';
import 'package:frontend_progetto_piattaforme/models/Constants.dart';
import 'package:frontend_progetto_piattaforme/models/LogInResult.dart';

class Model{
  static Model sharedInstance = Model();

  RestManager _restManager = RestManager();
  late AuthenticationData _authenticationData;


  Future<LogInResult> logIn(String email, String password) async {
    try{
      Map<String, String> params = Map();
      params["grant_type"] = "password";
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["username"] = email;
      params["password"] = password;
      String result = await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGIN, params, type: TypeHeader.urlencoded);
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      if ( _authenticationData.hasError() ) {
        if ( _authenticationData.error == "Invalid user credentials" ) {
          return LogInResult.error_wrong_credentials;
        }
        else if ( _authenticationData.error == "Account is not fully set up" ) {
          return LogInResult.error_not_fully_setupped;
        }
        else {
          return LogInResult.error_unknown;
        }
      }
      _restManager.token = _authenticationData.accessToken;
      Timer.periodic(Duration(seconds: (_authenticationData.expiresIn! - 50)), (Timer t) {
        _refreshToken();
      });

      return LogInResult.logged;
    }
    catch (e) {
      return LogInResult.error_unknown;
    }
  }

  Future<bool> _refreshToken() async {
    try {
      Map<String, String> params = Map();
      params["grant_type"] = "refresh_token";
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["refresh_token"] = _authenticationData.refreshToken!;
      String result = await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGIN, params, type: TypeHeader.urlencoded);
      _authenticationData = AuthenticationData.fromJson(jsonDecode(result));
      if ( _authenticationData.hasError() ) {
        return false;
      }
      _restManager.token = _authenticationData.accessToken;
      return true;
    }
    catch (e) {
      return false;
    }
  }

  Future<bool> logOut() async {
    try{
      Map<String, String> params = Map();
      _restManager.token = null;
      params["client_id"] = Constants.CLIENT_ID;
      params["client_secret"] = Constants.CLIENT_SECRET;
      params["refresh_token"] = _authenticationData.refreshToken!;
      await _restManager.makePostRequest(Constants.ADDRESS_AUTHENTICATION_SERVER, Constants.REQUEST_LOGOUT, params, type: TypeHeader.urlencoded);
      return true;
    }
    catch (e) {
      return false;
    }
  }

  Future<String> getPaziente(String cf) async{
    return await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, "/paziente",{"cf":cf});
  }

  Future<String> getPazienti()async{
    return await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, "/pazienti");
  }

  Future<String> getMedici() async{
    return await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, "/medici");
  }

  Future<String> getPrestazioni() async{
    return await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, "/prestazioni");
  }

  Future<String> prenota(Prenotazione p)async{
    return await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, "addPrenotazione", p);
  }

  Future<String> nuovoPaziente(Paziente paziente)async{
    return await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, "/addPaziente", paziente);
  }
  
  Future<String> ricercaPrenotazione(Prenotazione p) async{
    return await _restManager.makePostRequest(Constants.ADDRESS_STORE_SERVER, "/prenotazioni",p);
  }
  
  Future<String> ricercaPrenotazioneByCf(String cf)async{
    return await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, "/prenotazioneCf",{"cf":cf});
  }

  Future<String> getPrenotazioneById(Map<String,String> params) async{
    return await _restManager.makeGetRequest(Constants.ADDRESS_STORE_SERVER, "/prenotazione", params);
  }
}