#' Pull Surveycto data in R
#'
#' This function pulls data from surveycto using their api. Typically, numeric fields will be read as character by R when downloaded using the api. The user will manually need to convert the object type as necessary.
#' @param formid character: is the Surveycto form id.
#' @param servername character: is the name of the Surveycto server.
#' @param username character: is the username for the account being used to login to the server.
#' @param password character: is the password for the account being used to login to the server.
#' @param key character: name of the private encryption file, if applicable. If it doesn't contain an absolute path, the file name is relative to the current working directory, getwd(). If the form is encrypted and a key is not provided, only the fields marked as publishable will be returned. Defaults to NULL.
#' @param newserver logical: TRUE for surveycto version 2.70 and above. FALSE otherwise. Default is TRUE.
#' @return A dataframe containing the formdata in wide format
#' @export

pull_data<-function(formid,servername,username,password,key=NULL,newserver=T){
  library(httr)
  library(jsonlite)
  library(readr)
  isdf<- FALSE
  waittime<-0
  if (is.null(key)) {
    while(!isdf){
      Sys.sleep(waittime)
      if (newserver){
        request<-GET(paste0("https://",servername,".surveycto.com/api/v2/forms/data/wide/json/",formid,"?date=0"),
                     authenticate(username,password))
      } else {
        request<-GET(paste0("https://",servername,".surveycto.com/api/v2/forms/data/wide/json/",formid,"?date=0"),
                     authenticate(username,password,type = "digest"))
      }
      text<-content(request,"text")
      import<-fromJSON(text,flatten = T)
      isdf<- is.data.frame(import)
      if(!isdf){
        waittime<-readr::parse_number(import$error$message) +1
      } else (waittime<-0)
    }
  } else {
    while(!isdf){
      Sys.sleep(waittime)
      if (newserver){
        request<-POST(paste0("https://",servername,".surveycto.com/api/v2/forms/data/wide/json/",
                             formid,"?date=0"),
                      authenticate(username,password),
                      body = list(private_key=upload_file(key)),
                      encode = "multipart")
      } else {
        request<-POST(paste0("https://",servername,".surveycto.com/api/v2/forms/data/wide/json/",
                             formid,"?date=0"),
                      authenticate(username,password,type = "digest"),
                      body = list(private_key=upload_file(key)),
                      encode = "multipart")
      }
      text<-content(request,"text")
      import<-fromJSON(text,flatten = T)
      isdf<- is.data.frame(import)
      if(!isdf){
        waittime<-readr::parse_number(import$error$message) +1
      } else (waittime<-0)
    }
  }
  return(import)
}
