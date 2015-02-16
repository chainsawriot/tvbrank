require(plyr)
require(stringr)


allstars <- read.csv("allstars.csv", stringsAsFactors = FALSE, header = FALSE)
stars <- str_split(allstars[,1], "[、\n]")

genDF <- function(x, stars, allstars) {
  ldply(stars[[x]], function(q) cbind(q, allstars[x,2:ncol(allstars)]))
}

impdata <- ldply(1:length(stars), genDF, stars = stars, allstars = allstars)
cleaned_names <- str_replace(str_replace(str_replace(impdata[,1], ".+：", ""), "\\[.+\\]", ""), "　", "")
cleaned_names[cleaned_names == "每集不同演出"] <- ""
cleaned_names[cleaned_names == "布偉傑"] <- "布韋傑"

impdata[,1] <- cleaned_names

impdata <- impdata[impdata[,1] != "",]


library('Matrix')
genIncidenceMatrix <- function(df) {
  A <- spMatrix(nrow=length(unique(df$actor)),ncol=length(unique(df$drama)),i = as.numeric(factor(df$actor)),j = as.numeric(factor(df$drama)),x = rep(1, length(as.numeric(df$actor))))
  row.names(A) <- levels(factor(df$actor))
  colnames(A) <- levels(factor(df$drama))
  return(tcrossprod(A))
}

colnames(impdata)[1:2] <- c("actor", "drama")

inci <- genIncidenceMatrix(impdata[,1:2])
require(igraph)
actorCol <- graph.adjacency(inci, "undirected", weighted = TRUE, diag = FALSE)
actevc <- evcent(actorCol)$vector
paste(names(head(sort(actevc, TRUE), 10)), collapse = "、")

require(plyr)
dramaevc <- ddply(data.frame(evc = actevc[match(impdata$actor, names(actevc))], drama = impdata$drama), .(drama), summarize, meanevc = mean(evc))
dramaevc[order(dramaevc$meanevc),]

require(ggplot2)
x <- ggplot(dramaevc, aes(x = meanevc)) + geom_dotplot(stackdir = "centerwhole", dotsize = 0.7, binwidth = 0.005) + scale_y_continuous(name = "", breaks = NULL) + xlab("電視劇演員平均 EVC")
ggsave(x, file = "stack.png", width = 12, height = 3, dpi = 600)

alldramas <- unique(impdata[,c(2,6,4,5)])

evcproducers <- data.frame(producer = alldramas[,2], evc = dramaevc[match(alldramas$drama, dramaevc$drama),2])

unique(as.character(evcproducers[,1]))

producers <- c("戚其義","梅小青","羅永賢","文偉鴻","潘嘉德","王心慰","唐基明","黃偉聲","莊偉建","張乾文","徐遇安"
,"林志華",
"關永忠",
"曾勵珍",
"羅鎮岳",
"方駿釗",
"劉家豪",
"徐正康",
"李添勝",
"梁家樹",
"蔡晶盛",
"曾志偉",
"陳維冠",
"陳耀全",
"梁家樹",
"羅香蘭",
"李艷芳",
"陳維冠",
"黃華麒",
"梁家樹",
"陳梁",
"魯書潮",
"蔡晶盛",
"霍澤基",
"梁家樹",
"潘嘉德",
"蕭顯輝",
"林志華",
"錢國偉",
"鄺業生",
"歐冠英",
"陳維冠")

uniprod <- unique(producers)
require(stringr)

evcproducers <- data.frame(producer = alldramas[,2], evc = dramaevc[match(alldramas$drama, dramaevc$drama),2])

getEvcProd <- function(x, evcproducers) {
  mean(evcproducers$evc[str_detect(evcproducers$producer, x)])
}
sort(sapply(uniprod, getEvcProd, evcproducers = evcproducers))

evcdramas <- cbind(alldramas, dramaevc[match(alldramas$drama, dramaevc$drama),2])
colnames(evcdramas)[5] <- "evc"

ddply(evcdramas, .(V5), summarize, meanevc = mean(evc))

tapply(evcdramas$evc, str_detect(evcdramas$V5, "時裝"), mean)
str_detect(evcdramas$V5, "時裝")
evcdramas$modern <- as.numeric(str_detect(evcdramas$V5, "時裝")) + 1
evcdramas$evc100 <- evcdramas$evc * 100

x <- ggplot(evcdramas, aes(x = evc100, , fill = factor(modern))) + geom_dotplot(stackgroups = TRUE, method = "histodot", dotsize = 0.7, binwidth = 0.5) + scale_y_continuous(name = "", breaks = NULL) + xlab("電視劇演員平均 EVC") +  scale_fill_discrete(name="劇集類型", breaks = c("1", "2"), labels = c("非時裝","時裝"))
ggsave(x, file = "stack.png", width = 12, height = 3, dpi = 600)

V(actorCol)$evc <- actevc
MVPonly <- induced.subgraph(actorCol, which(V(actorCol)$name %in% names(tail(sort(actevc), 40))), impl = "auto")

png("testgraph_famous.png", width = 1000, height = 1000)
plot(MVPonly, vertex.size = V(MVPonly)$evc * 10, vertex.label.cex = 2, vertex.color = "white", edge.width = (E(MVPonly)$weight / max(E(MVPonly)$weight)) * 3,  layout = layout.fruchterman.reingold, vertex.label.color = "black")
dev.off()
