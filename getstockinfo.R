# ���J�M��
#install.packages("rvest")

# �ޥήM��
library(rvest)

#�]�w�ɮ׭n�x�s�����|
setwd("C:/R")

#================================================
#�B�z�����function : �N�������ন�褸�����^��
#================================================
CNV_DATE <- function(colDate){
  
  #�n�ק諸��m�]�w
  count <- 1
  tempDate <- colDate
  
  for( i in colDate)
  {
    
    x <- i
    
    #�N���ꪺ����� / ���ΥX�~��� (106/09/01 �ন 2017-09-01)
    tmpY <- strsplit(x,"/")[[1]][1]
    Y <- as.integer(tmpY)+1911
    M <-strsplit(x,"/")[[1]][2]
    D <-strsplit(x,"/")[[1]][3]
    tempDate[count] <- paste(Y, M, D, sep = "-")
    count <- count +1
  }
  return(tempDate)
}


#================================================
# �b���o�w�n�쪺�Ѳ��N��,�~��,���
#================================================

#�Ѳ��N��
stockNo <- "0050"

#�~
y <- c(2016:2017) #�]�i�Φ��覡�]�w c(2015,2016,2017)

#���
m <- c("01","02","03","04","05","06","07","08","09","10","11","12")




#================================================
#�զX�n�h�x�W�ҥ�ҧ�ѻ������}
#================================================
ur11 <- "http://www.twse.com.tw/exchangeReport/STOCK_DAY?response=html&date="
ur12 <- "&stockNo="
url3 <- stockNo
urlSet <- rbind()

for( i in y)
{

  for( j in m)
  {
    link <- paste(ur11,i, j, "01", ur12,url3,sep = "")
    urlSet <- rbind(urlSet,link)
  }
}




#================================================
#�}�l���ƨ��x�s�� csv
#�ɮ���� : ���(Date) �}�L��(O)	�̰���(H)	�̧C��(L)	���L��(C) ����i��(v)
#================================================
table <- rbind()

for( i in urlSet)
{

  ur1 <- i
  
  page.source <- read_html(ur1)
  colDate <- page.source  %>% html_nodes('body > div > table > tbody > tr:nth-child(n) > td:nth-child(1)') %>% html_text()
  newDate <- CNV_DATE(colDate)
  
  colO <- page.source  %>% html_nodes('body > div > table > tbody > tr:nth-child(n) > td:nth-child(4)') %>% html_text()
  colO <- as.numeric(colO)
  
  colH <- page.source  %>% html_nodes('body > div > table > tbody > tr:nth-child(n) > td:nth-child(5)') %>% html_text()
  colH <- as.numeric(colH)
  
  colL <- page.source  %>% html_nodes('body > div > table > tbody > tr:nth-child(n) > td:nth-child(6)') %>% html_text()
  colL <- as.numeric(colL)
  
  colC <- page.source  %>% html_nodes('body > div > table > tbody > tr:nth-child(n) > td:nth-child(7)') %>% html_text()
  colC <- as.numeric(colC)
  
  colV <- page.source  %>% html_nodes('body > div > table > tbody > tr:nth-child(n) > td:nth-child(9)') %>% html_text()
  colV <- sub(",","",colV)
  colV <- as.numeric(colV)
  
  tempTable <- cbind(newDate,colO,colH,colL,colC,colV)
  table2df <- as.data.frame(tempTable,stringsAsFactors = FALSE)
  table <- rbind(table,table2df)
}  

#�[�W���W��
colnames(table) <- c("Date","O","H","L","C","V")

#�g�Jcsv
write.table(table, file = paste(stockNo,".csv",sep = ""), sep = ",",row.names = FALSE)

#View(table)


