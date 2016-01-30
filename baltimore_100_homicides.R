# Get 100 recent homicide victims as HTMLfrom Baltimore Sun's website
library(rvest)
url <- "http://data.baltimoresun.com/news/police/homicides/recenthundred.php"
parsedHTML <- read_html(url)

# Create a list of nodes from the div tags which store the values
nodes <- html_nodes(parsedHTML, xpath="//div[@class='recentvictims']/div")

# Get column names as attributes from first node, remove first two characters
myattr <- nodes[1] %>% html_children %>% html_attr(name = "class")
mycolnames <- substr(myattr, 3, nchar(myattr))

# Import remaining nodes as text into a matrix and convert to a data.frame
homicides <- nodes[-1] %>% html_children() %>% html_text() %>% 
    matrix(nrow=100, ncol=6, byrow=T, dimnames=list(c(1:100), mycolnames)) %>%
    as.data.frame(stringsAsFactors=F)

# Convert column types from character
homicides$date <- as.POSIXct(homicides$date, format="%Y-%m-%d %H:%M %p", 
                             tz="America/New_York")
homicides$gender <- as.factor(homicides$gender)
homicides$race <- as.factor(homicides$race)
homicides$age <- as.integer(homicides$age)