ppsqlite <- function(db_file) {
  # Load the required libraries
  library(RSQLite)
  library(dplyr)
  library(knitr)

  # Connect to the database
  con <- dbConnect(SQLite(), dbname = db_file)

  # Get a list of all tables in the database
  tables <- dbListTables(con)

  # Loop over each table and print its structure
  for (table_name in tables) {
    cat("\n", paste(rep("=", 20), collapse = ""), "\n")
    cat("Table:", table_name, "\n")
    db_table <- dbReadTable(con, table_name)

    # Get the names and data types of the columns
    column_info <- sapply(db_table, class)
    names(column_info) <- names(db_table)

    # Print the column information
    cat("Columns:\n")
    kable(tibble(column_name = names(column_info),
                 column_type = column_info),
          format = "pandoc",
          row.names = FALSE,
          caption = "Column Information")

    # Print the number of rows
    cat("Rows:", nrow(db_table), "\n")

    # Print the first 6 rows of the table
    cat("Sample Data:\n")
    head(db_table, 6)
  }

  # Disconnect from the database
  dbDisconnect(con)
}
