#' Manually specify coordinates to display the network
#'
#' @param cor Correlation matrix
#' @param nodeGroup Classification information of network nodes
#' @param r Radius of each submodule
#' @param da The coordinates of each submodule
#' @examples
#' data(ps)
#' result = corMicro (ps = ps,N = 0.02,r.threshold=0.8,p.threshold=0.05,method = "pearson")
#' #Extract correlation matrix
#' cor = result[[1]]
#' # building the node group
#' netClu = data.frame(ID = row.names(cor),group =rep(1:3,length(row.names(cor)))[1:length(row.names(cor))] )
#' netClu$group = as.factor(netClu$group)
#' @return list
#' @author Contact: Tao Wen \email{2018203048@@njau.edu.cn} Jun Yuan \email{junyuan@@njau.edu.cn}
#' @references
#'
#' Yuan J, Zhao J, Wen T, Zhao M, Li R, Goossens P, Huang Q, Bai Y, Vivanco JM, Kowalchuk GA, Berendsen RL, Shen Q
#' Root exudates drive the soil-borne legacy of aboveground pathogen infection
#' Microbiome 2018,DOI: \url{doi: 10.1186/s40168-018-0537-x}
#' @export



ArtifCluster = function(cor = cor,nodeGroup =netClu,r = r,da =da){
  for (i in 1:length(levels(nodeGroup$group))) {
    #--Extract all otu in this group
    as = dplyr::filter(nodeGroup, group == levels(nodeGroup$group)[i])
    if (length(as$ID) == 1) {
      data = cbind(da[i,1],da[i,2] )
      data =as.data.frame(data)
      row.names(data ) = as$ID
      data$elements = row.names(data )
      colnames(data)[1:2] = c("X1","X2")
    }
    as$ID = as.character( as$ID)
    # Calculation of a single circular coordinate
    if (length(as$ID)!=1 ) {
      m = cor[as$ID,as$ID]
      d  =m
      d <- as.edgelist.sna(d)
      n <- attr(d, "n")
      s = r[i]
      data = cbind(sin(2 * pi * ((0:(n - 1))/n))*s +da[i,1], cos(2 * pi * ((0:(n - 1))/n))*s +da[i,2])
      data =as.data.frame(data)
      row.names(data ) = row.names(m)
      data$elements = row.names(data )
      colnames(data)[1:2] = c("X1","X2")
    }
    if (i == 1) {
      oridata = data
    }
    if (i != 1) {
      oridata = rbind(oridata,data)
    }
  }
  plotcord = oridata[match(oridata$elements,row.names(cor )),]
  return(list(plotcord,da))
}
