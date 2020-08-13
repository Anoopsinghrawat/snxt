#' Save Surveycto media files using R
#'
#' This function saves the media that were collected during the survey. pull_media should be used once data is downloaded using pull_data and an R dataframe is generated. In the data frame, the media variable will contain links that will be used to download the media files
#' @param df is the name of the dataframe which contains surveycto data downloaded using pull_data.
#' @param variable character: is the name of the form variable which contains the media.
#' @param username character: is the username for the account being used to login to the server.
#' @param password character: is the password for the account being used to login to the server.
#' @param folder character: is the absolute path to the folder where the media files will be downloaded.
#' @param uidvar character: any unique id from the df dataset. This variable is used to name the media files. This variable shouldn't contain special characters such as (: , ; ') as such characters aren't allowed in the filename.
#' @param fileformat character: is the format in which to save the file. Examples - jpg, png, mp3
#' @param key character: name of the private encryption file, if applicable. If it doesn't contain an absolute path, the file name is relative to the current working directory, getwd(). If the form is encrypted and a key is not provided, only the fields marked as publishable will be returned. Defaults to NULL.
#' @return The media files corresponding to the required variable will be downloaded in the specified folder.
#' @examples
#' pull_media("dataframe_formdata","respondent_picture","user(at)gmail.com","passwordhere","C:/Users//Dropbox/projectfolder/mediafiles/pictures","jpg")
#' pull_media("dataframe_formdata","respondent_picture","user(at)gmail.com","passwordhere","C:/Users//Dropbox/projectfolder/mediafiles/pictures","jpg",key="C:/Users/Dropbox/projectfolder/encryption_keys/projectdata_PRIVATEDONOTSHARE.pem")
#' @export

pull_media<-function(df,variable,username,password,folder,uidvar,fileformat,key=NULL) {
  if (is.null(key)) {
    for (i in 1:nrow(df)) {
      url<-df[i,variable]
      request<- httr::GET(url,httr::authenticate(username,password))
      bytes<-httr::content(request,"raw")
      writeBin(object = bytes,con = paste0(folder,"//",df[i,uidvar],".",fileformat)) }
  } else {
    for(i in 1:nrow(df)) {
      url<-df[i,variable]
      request <- httr::POST(url, httr::authenticate(username,password),
                            body = list(private_key = httr::upload_file(key)),
                            encode = "multipart")
      bytes<-httr::content(request,"raw")
      writeBin(object = bytes,con = paste0(folder,"//",df[i,uidvar],".",fileformat))
    }
  }
}
