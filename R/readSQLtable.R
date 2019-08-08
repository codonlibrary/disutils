#' Read SQL from Databricks
#' 
#' Reading an SQL table from Databricks assumes that the user already has Databricks credentials
#' and access rights to a particular Databricks cluster. 
#'
#' @param tableName  Name of the table to read.
#' @param token DataBricks token. IT IS PERSONAL TO YOU. 
#' @param query SQL query. Default: "SELECT * FROM tableName"
#' @param hostName Server host name. Default: "db.ref.core.data.digital.nhs.uk"
#' @param httpPath HTTP path to the Databricks cluster. Default: "sql/protocolv1/o/0/rstudio-pilot"
#' 
#' @return The SQL table.
#'
#' @examples
#' 
#' @export 

readSQLtable <- function(tableName, token, query = NULL, hostName = NULL, 
                         httpPath = NULL){
  
  if(is.null(query)){ 
    query <- paste("SELECT * FROM ", tableName)
  }
  
  if(is.null(hostName)){
    hostName <- "db.ref.core.data.digital.nhs.uk"
  }
  
  if(is.null(httpPath)){
    httpPath = "sql/protocolv1/o/0/rstudio-pilot"
  }
  
  con <- tryCatch(
    DBI::dbConnect(drv = odbc::odbc(),
                   "Databricks",
                   host = hostName,
                   pwd =  token,
                   httppath = httpPath),
    error = function(err){
      stop("Creating a connection to the external database failed.");
      return(NaN)
    }
  )
  
  result <- tryCatch(
    DBI::dbSendQuery(conn = con, statement = query),
    error = function(err){
      DBI::dbDisconnect(con)
      stop("The SQL query used failed to evaluate.");
      return(NaN)
    }
  )
  
  resData <- tryCatch(
    DBI::dbFetch(result), 
    error = function(err){
      stop("Fetchig the records failed.");
      return(NaN)
    },
    finally = {
      DBI::dbClearResult(result);
      DBI::dbDisconnect(con);
    }
  ) 
  

  
  return(resData)
  
}

