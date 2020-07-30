#' Dismounts veracrypt container directly from R
#'
#' This function dismounts the veracrypt container directly from R
#' @param drive character: name of the drive from which to dismount the volume. Example - "Z://"
#' @param vcexecutable character: name of the veracrypt executable file. If it doesn't contain an absolute path, the file name is relative to the current working directory, getwd(). Default is "C:/Program Files/VeraCrypt/VeraCrypt.exe"
#' @return Running the function will dismount the veracrypt volume as specified. Returns a NULL object in R.
#' @export
vc_dismount<-function(drive,vcexecutable="C:\\Program Files\\VeraCrypt\\VeraCrypt.exe"){
  system(paste("\"",vcexecutable,"\"", ' /d ', "K://",' /b',sep = ""),wait = F)
  while(dir.exists(drive)){

  }
}
