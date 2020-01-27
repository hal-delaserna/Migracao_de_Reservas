# rm(list = ls())

# library(tidyverse)
 #__________________________________


# procura todos os anos, CICLO ----

for (ano in 2014:2018) {
  eventos <-
    as.list(c('processos_Bloqueio_ART42',
        'processos_CADUC',
        'processos_Cessao_Total',
        'processos_Cessao_Parcial',
        'processos_desmembramento',
        'processos_INCORPORACAO',
        'processos_RRR'))
  
  caminho <- list()
  for (i in 1:length(eventos)) {
    caminho[i] <-
      paste("./Eventos_", ano, "/", eventos[i], ".xls", sep = "")
  }
  
  
  for (j in 1:length(eventos)) {
    
    eventos[j] <-
      xml2::read_html(x = caminho[[j]], encoding = "ANSI") %>%
      rvest::html_table()}
    
    
  
  # Não migrar
  processos_Bloqueio_ART42 <- data.frame(eventos[1])
  processos_CADUC <- data.frame(eventos[2])
  processos_RRR <- data.frame(eventos[7])
  # antes de migrar fazer importação RPA (RRR): o sys alertará sobre existência prévia de reserva RRR
  
  # alteração de títular
  processos_Cessao_Total <- data.frame(eventos[3])
  processos_Cessao_Parcial <- data.frame(eventos[4])
  processos_desmembramento <- data.frame(eventos[5])
  processos_INCORPORACAO <- data.frame(eventos[6])
  
  Nao_Migrar <-
    bind_rows(
      processos_Bloqueio_ART42,
      processos_CADUC,
      processos_RRR)
  
  alteracao_titular <- 
    bind_rows(processos_Cessao_Parcial,
              processos_Cessao_Total,
              processos_desmembramento,
              processos_INCORPORACAO)
  

  
  write.table(
    x = Nao_Migrar$X1,
    file = paste("./Nao_migrar/Nao_Migrar_", ano, ".csv", sep = ""),
    sep = ";",
    row.names = FALSE,
    quote = FALSE)
  
  write.table(
    x = alteracao_titular$X1,
    file = paste("./Nao_migrar/alteracao_titular_", ano, ".csv", sep = ""),
    sep = ";",
    row.names = FALSE,
    quote = FALSE
  )}




# BUSCA INDIVIDUAL----

ano <- 2017
eventos <-
  as.list(c('processos_Bloqueio_ART42','processos_CADUC','processos_Cessao_Total',
            'processos_Cessao_Parcial','processos_desmembramento','processos_INCORPORACAO',
            'processos_RRR'))



processos_Bloqueio_ART42 <-
  data.frame(rvest::html_table(xml2::read_html(
    paste("./Eventos_", ano, "/", eventos[1], ".xls", sep = ""),
    encoding = "ANSI")))
  
processos_CADUC <-
  data.frame(rvest::html_table(xml2::read_html(
    paste("./Eventos_", ano, "/", eventos[2], ".xls", sep = ""),
    encoding = "ANSI")))

processos_RRR <-
  data.frame(rvest::html_table(xml2::read_html(
    paste("./Eventos_", ano, "/", eventos[7], ".xls", sep = ""),
    encoding = "ANSI")))



# antes de migrar fazer importação RPA (RRR): o sys alertará sobre existência prévia de reserva RRR

# alteração de títular
processos_Cessao_Total <-
  data.frame(rvest::html_table(xml2::read_html(
    paste("./Eventos_", ano, "/", eventos[3], ".xls", sep = ""),
    encoding = "ANSI")))

processos_Cessao_Parcial <-
  data.frame(rvest::html_table(xml2::read_html(
    paste("./Eventos_", ano, "/", eventos[4], ".xls", sep = ""),
    encoding = "ANSI")))

processos_desmembramento <-
  data.frame(rvest::html_table(xml2::read_html(
    paste("./Eventos_", ano, "/", eventos[5], ".xls", sep = ""),
    encoding = "ANSI")))

processos_INCORPORACAO <-
  data.frame(rvest::html_table(xml2::read_html(
    paste("./Eventos_", ano, "/", eventos[6], ".xls", sep = ""),
    encoding = "ANSI")))





#____________________________________________

# lista de processos disponíveois para migrar todos os anos



Listagem_Processos_Migrar_todosANOS <- 
  read.table("Listagem_Processos_Migrar_todosANOS.csv", encoding = "ANSI", 
             sep = ";", header = FALSE, fill = TRUE, quote = "")



listagem_2015 <- 
  Listagem_Processos_Migrar_todosANOS[Listagem_Processos_Migrar_todosANOS$V2=='2015',]$V3 %>% unique() 



anti_join(data.frame(listagem_2015), 
          data.frame(Nao_Migrar_eventos2015), 
          by = c("listagem_2015" = "Nao_Migrar_eventos2015"))



