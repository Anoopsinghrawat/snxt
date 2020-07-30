#' Mounts veracrypt container directly from R
#'
#' This function mounts the veracrypt container directly from R
#' @param filename character: name of the veracrypt container. If it doesn't contain an absolute path, the file name is relative to the current working directory, getwd().
#' @param drive character: drive name. Example - "Z://"
#' @param password character: password of the veracrypt container.
#' @param vcexecutable character: name of the veracrypt executable file. If it doesn't contain an absolute path, the file name is relative to the current working directory, getwd(). Default is "C:/Program Files/VeraCrypt/VeraCrypt.exe"
#' @return Running the function will open veracrypt as specified. Returns a NULL object in R.
#' @examples
#' vc_mount("C:/User/Dropbox/Project1/raw_data/veracrypt_raw", "k://", "veracryptpassword")
#'
#' vc_mount(filename="C:/User/Dropbox/Project1/raw_data/veracrypt_raw", drive="k://", password="veracryptpassword", vcexecutable="C:/Program Files (x86)/VeraCrypt/VeraCrypt.exe")
#'
#' @export

vc_mount<-function(filename,drive,password,vcexecutable="C:\\Program Files\\VeraCrypt\\VeraCrypt.exe") {
  if(dir.exists(drive)) {
    e<-base::simpleError(paste("Drive",drive, "is not available. Either unmount the volume from this drive or select an available drive"))
    stop(e)
  } else {
    system(paste("\"",vcexecutable,"\"", ' /v ' , "\"" ,filename,"\"",' /l ', drive,' /a /p ', password,' /e /b',sep = ""),wait = F)
    while(!dir.exists(drive)) {

    }
  }
}
