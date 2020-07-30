#' Pull Surveycto data in R
#'
#' This function pulls data from surveycto using their api. Typically, numeric fields will be read as character by R when downloaded using the api. User will manually need to convert the field types as necessary.
#' @param formid character: is the Surveycto form id.
#' @param servername character: is the name of the Surveycto server.
#' @param username character: is the username for the account being used to login to the server.
#' @param password character: is the password for the account being used to login to the server.
#' @param key character: name of the private encryption file, if applicable. If it doesn't contain an absolute path, the file name is relative to the current working directory, getwd(). If the form is encrypted and a key is not provided, only the fields marked as publishable will be returned. Defaults to NULL.
#' @param newserver logical: TRUE for surveycto version 2.70 and above. FALSE otherwise. Default is TRUE.
#' @return A dataframe containing the formdata in wide format
#' @examples
#' gp_survey<- pulldata("gp_survey_v1","gpcovid19","user(at)gmail.com","difficultpassword$793")
#' gp_survey_encrypted<-pulldata("gp_survey_v1","gpcovid19","user(at)gmail.com","difficultpassword$793", key="C:/Users/Dropbox/gp_project/encryption_keys/gpkey_PRIVATEDONOTSHARE.pem")
#' @export

pull_data<-function(formid,servername,username,password,key=NULL,newserver=T){
  isdf<- FALSE
  waittime<-0
  if (is.null(key)) {
    while(!isdf){
      Sys.sleep(waittime)
      if (newserver){
        request<-httr::GET(paste0("https://",servername,".surveycto.com/api/v2/forms/data/wide/json/",formid,"?date=0"),
                     authenticate(username,password))
      } else {
        request<-httr::GET(paste0("https://",servername,".surveycto.com/api/v2/forms/data/wide/json/",formid,"?date=0"),
                     authenticate(username,password,type = "digest"))
      }
      text<-httr::content(request,"text")
      import<-jsonlite::fromJSON(text,flatten = T)
      isdf<- is.data.frame(import)
      if(!isdf){
        waittime<-readr::parse_number(import$error$message) +1
      } else (waittime<-0)
    }
  } else {
    while(!isdf){
      Sys.sleep(waittime)
      if (newserver){
        request<-httr::POST(paste0("https://",servername,".surveycto.com/api/v2/forms/data/wide/json/",
                             formid,"?date=0"),
                      authenticate(username,password),
                      body = list(private_key=upload_file(key)),
                      encode = "multipart")
      } else {
        request<-httr::POST(paste0("https://",servername,".surveycto.com/api/v2/forms/data/wide/json/",
                             formid,"?date=0"),
                      authenticate(username,password,type = "digest"),
                      body = list(private_key=upload_file(key)),
                      encode = "multipart")
      }
      text<-httr::content(request,"text")
      import<-jsonlite::fromJSON(text,flatten = T)
      isdf<- is.data.frame(import)
      if(!isdf){
        waittime<-readr::parse_number(import$error$message) +1
      } else (waittime<-0)
    }
  }
  return(import)
}
