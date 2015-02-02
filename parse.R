require(XML)

z <- readHTMLTable("http://zh.wikipedia.org/zh-hk/%E5%B9%B8%E7%A6%8F%E6%91%A9%E5%A4%A9%E8%BC%AA")
z <- readHTMLTable("http://zh.wikipedia.org/zh-hk/%E6%83%85%E8%B6%8A%E6%B5%B7%E5%B2%B8%E7%B7%9A")
z <- readHTMLTable("http://zh.wikipedia.org/zh-hk/%E7%A5%9E%E9%8E%97%E7%8B%99%E6%93%8A")
z <- readHTMLTable("http://zh.wikipedia.org/zh-hk/%E4%B9%9D%E4%BA%94%E8%87%B3%E5%B0%8A")
z <- readHTMLTable("http://zh.wikipedia.org/zh-hk/%E6%B0%B4%E6%BB%B8%E7%84%A1%E9%96%93%E9%81%93")

checkTable <- function(x) {
    colnames(x[1]) == c("演員")
}

extractActors <- function(x) {
    as.character(x[,1])
}

require(stringr)

allactors <- Reduce(c, Map(extractActors, Filter(checkTable, z))) ## haven't remove duplicates and anything inside parens
genre <- as.character(z[[1]][z[[1]][1] == "類型",2])
processedallactors <- Filter(function(x) x!="", unique(str_replace_all(str_replace_all(allactors, "（.+）", ""), "　|\\n", "")))

