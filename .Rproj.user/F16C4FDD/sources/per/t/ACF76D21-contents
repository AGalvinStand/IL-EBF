# PURPOSE ---------

#   Test script to see work out a function to find the tier 1 target ratio.

# PREPARED BY ------

# Chris Poulos

# 2022-10-19

# Let's go! - <('.' <)

# Bring in 4 key calculations ---------------------

source("scripts/ebf_base_calc.R")

# 

# step one iterate through percentages to 

test <- ebf_base_calc

test$blah <- ave(test$final_percent_adequacy,test$FUN=cumsum)

test$id <- cumsum(test[13])

ebf_base_calc$gap <- 1


gap <- function(y) {
  a<-y
  if(ebf_base_calc$final_percent_adequacy < y) {
    return(sum((a*ebf_base_calc$final_adequacy_target)-ebf_base_calc$final_resources))
  }
}
  return(y)
  ebf_base_calc$gape <- y
    
}
    case_when(y > ebf_base_calc$final_adequacy_target ~ (y*ebf_base_calc$final_adequacy_target)-ebf_base_calc$final_resources,
                                 FALSE ~ 0)
  a <- sum(ebf_base_calc$gap)
}  
  ifelse(ebf_base_calc$final_percent_adequacy < y, cumsum((y*ebf_base_calc$final_adequacy_target)-ebf_base_calc$final_resources), 0)
}
  
  ebf_base_calc$gap <- case_when(ebf_base_calc$final_percent_adequacy < y ~ (y*ebf_base_calc$final_adequacy_target)-ebf_base_calc$final_resources,
                                 FALSE ~ 0)
}    
    ifelse(ebf_base_calc$final_percent_adequacy < y, (y*ebf_base_calc$final_adequacy_target)-ebf_base_calc$final_resources, 0)
}
  
gap(.7)
  
    ebf_base_calc$gap = (y*ebf_base_calc$final_adequacy_target)-ebf_base_calc$final_resources
  
  
  ifelse(ebf_base_calc$final_percent_adequacy < y,cumsum(ebf_base_calc$gap),0)
  }


tr <- function(x, lower, upper) {
  optimize(function(y) abs(gap(y) - x), lower=lower, upper=upper)
}



tr(500000000, 0.600000000000000, .800000000000000)



