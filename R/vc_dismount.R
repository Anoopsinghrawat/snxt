#' Dismounts veracrypt container directly from R
#'
#' This function dismounts the veracrypt container directly from R
#' @param drive character: name of the drive from which to dismount the volume. Example - "Z://"
#' @param vcexecutable character: name of the veracrypt executable file. If it doesn't contain an absolute path, the file name is relative to the current working directory, getwd(). Default is "C:/Program Files/VeraCrypt/VeraCrypt.exe"
#' @return Running the function will dismount the veracrypt volume as specified. Returns a NULL object in R.
#' @examples
#' vc_dismount("k://")
#'
#' vc_dismount("k://", vcexecutable="C:/Program Files/Veracrypt/Veracrypt.exe")
#'
#' vc_dismount("k://", vcexecutable="C:/Program Files (x86)/Veracrypt/Veracrypt.exe")
#' @export
vc_dismount<-function(drive,vcexecutable="C:\\Program Files\\VeraCrypt\\VeraCrypt.exe"){
  system(paste("\"",vcexecutable,"\"", ' /d ', drive,' /b',sep = ""),wait = F)
  while(dir.exists(drive)){

  }
}
