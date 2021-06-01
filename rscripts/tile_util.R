library(shiny)
library(shinyWidgets)

generate_tiles <- function(df, tiles_name, title_col, label_col) {
  title <- df[, title_col] %>%
            unique()
  container <- tags$div(
    tags$h3(title)
  )
  tiles <- tags$div(
    tags$style(".dd_table, .dd_table_row, .dd_table_col {
                  border: 1px solid black;
                  border-collapse: collapse;
                }
                .dd_table_col {
                  padding:7px;
                }
               .btn {
                  width: 100%;
                  text-align: left;
               }
               .glyphicon {
                  float: right;
               }"),
    tags$h4(tiles_name, style="margin-top:0px;")
  )
  for (row in 1:nrow(df)) {
    tile <- tags$table(class="dd_table")  
    cols <- names(df)
    cols <- cols[!cols %in% c(label_col, title_col)]
    for (col in cols) {
      data_field <- as.character( df[row, col] )
      table_row <- tags$tr(class="dd_table_row")
      table_row <- tagAppendChild(table_row, tags$td(col, class="dd_table_col") )
      table_row <- tagAppendChild(table_row, tags$td(data_field, class="dd_table_col")) 
      tile <- tagAppendChild(tile, table_row )
    }
    tile_label = paste(df[row, label_col]) 
    tile <- dropdown(tile, label=tile_label, block=TRUE)
    tiles <- tagAppendChild(tiles, tile)
  }  
  tiles <- tagAppendChild(wellPanel(), tiles)
  tiles <- tagAppendChild(container, tiles)
  return(tiles)
}