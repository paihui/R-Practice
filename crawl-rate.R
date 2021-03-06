#============================================================
# Demo1 : 網頁爬蟲
#============================================================

#安裝套件
install.packages("xml2")
install.packages("rvest")


#引用套件����
library(xml2)
library(rvest)

#設定抓取的網址 : 台灣銀行匯率資料
rateurl <-"http://rate.bot.com.tw/xrt"

#抓取網頁
ratepage <- read_html(rateurl,encoding="UTF-8")

#將抓到的網頁儲存
setwd("C:/BigDataSpark/R")
write_xml(ratepage,file="ratepage.txt")

#轉碼
ratepage %>% iconv(from = 'UTF-8', to = 'UTF-8')
ratepage

#取出匯率日期,幣別及匯率

#取出日期並轉成日期格式
time <-  ratepage %>% html_nodes('.time') %>% html_text()
time <- as.Date(time)

#取出幣別
cury <- ratepage %>% html_nodes('tbody') %>% html_nodes('.print_show') %>% html_text()
cury
#將不必要的字元移除
replacePunctuation <- function(x) { gsub("[[:punct:]]+", " ", x) }
sapply(cury,replacePunctuation)
#body > div.page-wrapper > main > div:nth-child(4) > table > tbody > tr:nth-child(1) > td:nth-child(3)

#取出匯率
rate <- ratepage  %>% html_nodes('tbody > tr:nth-child(n) > td:nth-child(3)') %>% html_text()
rate

#將資料存進dataframe
datarate <- data.frame(日期=time,幣別=cury, 匯率=rate)

#檢視資料      
View(datarate)
