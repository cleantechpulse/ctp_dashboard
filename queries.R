source("settings.txt")

conn <- dbConnect(
  drv = dbDriver(app.settings$db.type),
  dbname = app.settings$db.name,
  host = app.settings$db.host,
  port = app.settings$db.port,
  user = app.settings$db.user,
  password = app.settings$db.password)

csi_query <- 'SELECT zip_code,
SUM (nameplate_capacity) as total_capacity,
COUNT (nameplate_capacity) as total_systems
FROM systems
GROUP BY zip_code;'

# query = 'SELECT * FROM systems LIMIT 50;'

csi_rs <- dbSendQuery(conn, csi_query)

zip.summary <- dbFetch(csi_rs)

dbClearResult(csi_rs)
dbDisconnect(conn)

