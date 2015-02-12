alldata <- read.csv("alldata_mod.csv", stringsAsFactors = FALSE, header = FALSE)
addition2 <- read.csv("additionalData2.csv", stringsAsFactors = FALSE, header = FALSE)
addition1 <- read.csv("additionalData.csv", stringsAsFactors = FALSE, header = FALSE)

alldata <- rbind(alldata, addition1, addition2)
require(stringr)
#table(alldata$V2)

clean_names <- str_replace(alldata$V1, "（.+）", "")
clean_names <- str_replace(clean_names, "　+", "")
clean_names <- str_replace(clean_names, "　+", "")

clean_names <- str_replace(clean_names, "\\(.+\\)", "")
clean_names <- str_replace(clean_names, " ", "")

alldata$V1 <- clean_names

require(plyr)
cleandata <- ddply(alldata, .(V2), unique)

#alldata[substring(clean_names, 1, 1) %in% names(table(substring(clean_names, 1, 1))[table(substring(clean_names, 1, 1)) < 2]),]

#freqnames <- names(sort(table(cleandata$V1))[sort(table(cleandata$V1)) > 10])
#rarenames <- sort(table(cleandata$V1))[sort(table(cleandata$V1)) <= 10]
#adist(rarenames[40], freqnames)

#closenames <- lapply(names(rarenames), function(x) freqnames[as.vector(adist(x, freqnames) == 1)] )

distanceRefine <- function(x, threshold, alldata,maxd = 1) {
  freqnames <- names(sort(table(x))[sort(table(x)) > threshold])
  rarenames <- sort(table(x))[sort(table(x)) <= threshold]
  y <- x
  closenames <- lapply(names(rarenames), function(x) freqnames[as.vector(adist(x, freqnames) <=  maxd)] )
  for (i in 1:length(rarenames)) {
    if (length(closenames[[i]]) > 1) {
      print(rarenames[i])
      print("Possible Replacement Available")
      for (j in 1:length(closenames[[i]])) {
        print(paste(j, closenames[[i]][j]))
      }
      breakOut <- TRUE
      while (breakOut) {
        n <- as.numeric(readline("Replace (0 to Skip, -1 to check): "))
        if (n == 0) {
          breakOut <- FALSE
        } else if (n == -1) {
          print(cleandata[cleandata$V1 == names(rarenames[i]),])
        } else if (n > length(closenames[[i]])) {
          print('Invalid Input')
        } else if (n == -2) {
          print ('Break')
          return(y)
        } else {
          y[y == names(rarenames[i])] <- closenames[[i]][n]
          breakOut <- FALSE
        }
      }
    }
  }
  return(y)
}

z <- distanceRefine(cleandata$V1, 20, cleandata)

z2 <- distanceRefine(z, 15, cleandata)

z3 <- distanceRefine(z2, 5, cleandata)

z4 <- distanceRefine(z3, 3, cleandata)

z5 <- distanceRefine(z4, 2, cleandata)

                                        # Manual messaging
z5[z5=="梁證嘉"] <- "梁証嘉"
z5[str_detect(z5, "^游.$")] <- "游飈"
z5[str_detect(z5, "^陳嘉佳$")] <- "小寶"
z5[str_detect(z5, "^Anders")] <- "聶安達"
z5[str_detect(z5, "^黃.瑩")] <- "黃紀瑩"
z5[str_detect(z5, "^蘇恩")] <- "蘇恩磁"
z5[str_detect(z5, "^蘇思")]<- "蘇恩磁"
z5[str_detect(z5,"^黎柏")] <- "黎柏麟"
z5[str_detect(z5,"^黎栢")] <- "黎柏麟"
z5[str_detect(z5,"^黎彼")] <- "黎彼得"
z5[str_detect(z5,"^黃.晴")] <- "黃芓晴"
z5[str_detect(z5,"^黃澤.")] <- "黃澤鋒"
z5[str_detect(z5,"^黃[柏栢]文")] <- "黃栢文"
z5[str_detect(z5,"^魏.皓")] <- "魏焌皓"
z5[str_detect(z5,"顏桂")] <- "顏桂洲"
z5[str_detect(z5,"顧桂州")]<- "顏桂洲"
z5[str_detect(z5, "顏國")] <- "顏國樑"
z5[str_detect(z5, "霍.邦")] <- "霍健邦"
z5[str_detect(z5, "陸永")] <- "陸永"
z5[str_detect(z5, "陳良")] <- "陳良韋"
z5[str_detect(z5, "關[婉宛]")] <- "關婉珊"
z5[str_detect(z5, "關.姍")] <- "關婉珊"
z5[str_detect(z5, "鍾鈺")] <- "鍾鈺精"
z5[str_detect(z5, "趙璧")] <- "趙璧瑜"
z5[str_detect(z5, "貝汶")] <- "貝汶琪"
z5[str_detect(z5, "謝欣.")] <- "謝欣延"
z5[str_detect(z5, "謝兆.")] <- "謝兆韻"
z5[str_detect(z5, "謝光")] <- "謝光耀"
z5[str_detect(z5, "莊.生")] <- "莊狄生"
z5[str_detect(z5, "胡.龍")] <- "胡烱龍"
z5[str_detect(z5, "翟.麟")] <- "翟兆麟"
z5[str_detect(z5, "盧海")] <- "盧海鵬"
z5[str_detect(z5, "游.維")] <- "游莨維"
z5[str_detect(z5, "江梓")] <- "江梓瑋"
z5[str_detect(z5, "樊.敏")] <- "樊亦敏"
z5[str_detect(z5, "梁咖.")] <- "梁珈詠"
z5[str_detect(z5, "林艾.")] <- "林艾瑩"
z5[str_detect(z5, "林欣[喜熹嘉]")] <- "林欣熹"
z5[str_detect(z5, "林映.")] <- "林映輝"
z5[str_detect(z5, "李日")] <- "李日昇"
z5[str_detect(z5, "朱樂.")] <- "朱樂洺"
z5[str_detect(z5, "於洋")] <- "于洋"
z5[str_detect(z5, ".石文")] <- "招石文"

z5[str_detect(z5, "布.傑")] <- "布偉傑"
z5[str_detect(z5, "宋.齡")] <- "宋芝齡"
z5[str_detect(z5, "姚.政")] <- "姚浩政"
z5[str_detect(z5, "姚.浩")] <- "姚浩政"

z5[str_detect(z5, "^嘉.$")] <- "嘉浚"
z5[str_detect(z5, "周寶.")] <- "周寶霖"
z5[str_detect(z5, "區.豪")] <- "區珀豪"
z5[str_detect(z5, "何婷.")] <- "何婷恩"
z5[str_detect(z5, "伍濼.")] <- "伍濼文"
z5[z5=="-"] <- ""

saveRDS(z5, "z5.RDS")

length(z5)
nrow(cleandata)

cleandata$V1 <- z5
cleandata <- ddply(cleandata, .(V2), unique)

cleandata <- cleandata[cleandata$V1 != "",]
saveRDS(cleandata, "cleandata.RDS")

cleandata$V1[str_detect(cleandata$V1, "黃鳳")] <- "黃鳳瓊"

cleandata$V1[str_detect(cleandata$V1, "顔桂州")] <- "顏桂洲"
cleandata$V1[str_detect(cleandata$V1, "陳榮.")] <- "陳榮峻"
cleandata$V1[str_detect(cleandata$V1, "邱.恩")] <- "邱詠恩"
cleandata$V1[str_detect(cleandata$V1, "譚.雯")] <- "譚靜雯"
cleandata$V1[str_detect(cleandata$V1, "許俊溢")] <- "許浚益"
cleandata$V1[str_detect(cleandata$V1, "^殷.$")] <- "殷櫻"
cleandata$V1[str_detect(cleandata$V1, "^柯.$")] <- "柯嵐"
cleandata$V1[str_detect(cleandata$V1, "杜大.")] <- "杜大偉"
cleandata$V1[str_detect(cleandata$V1, "李鴻.")] <- "李鴻杰"
cleandata$V1[str_detect(cleandata$V1, "朱.林")] <- "朱匯林"
cleandata$V1[str_detect(cleandata$V1, "戴志.")] <- "戴志偉" 
cleandata$V1[str_detect(cleandata$V1, "夏竹.")] <- "夏竹欣"
cleandata$V1[str_detect(cleandata$V1, "伍濼文")] <- "伍濼文"

cleandata <- ddply(cleandata, .(V2), unique)
saveRDS(cleandata, "cleandata.RDS")














