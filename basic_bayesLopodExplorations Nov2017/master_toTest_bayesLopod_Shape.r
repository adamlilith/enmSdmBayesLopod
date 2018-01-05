#Install from github

#devtools::install_github("camilosanin/bayesLopod/bayesLopod", dependencies = TRUE)
#library(bayesLopod)

#Load testing rasters (any other can be used)
AndroShape = shapefile("c:/GitHub/bayesLopod/AndropogonData/Andropogon_midUS.shp")
varData = rnorm(length(AndroShape), mean = 1, sd = 0.25)
AndroShape@data[,"anyAG"] = round(varData * AndroShape@data[,"anyAG"])
AndroShape@data[,"Sampling"] = round(AndroShape@data[,"poaRec"]*varData) + AndroShape@data[,"anyAG"]

# Create lopodObject
LopodObject = shapeLopodData(AndroShape, fieldN = "Sampling", fieldY = "anyAG", Adjacency = T, keepFields = F)
# Plot input data
spplot(LopodObject@geoDataObject, zcol ="FeatureID")

Andropogon_shape = LopodObject@geoDataObject
save("Andropogon_shape", file = "c:/GitHub/bayesLopod/Data/Andropogon_shape.rda")

#Run bayesLopod model (change settings tu run it for longer chains or different settings)
ModLopod = modelLopod(LopodObject, varP = F, q = NULL, CAR = T, pmin = 0, nChains = 1, warmup = 200, sampling = 100, nCores = 2)
lopodTrace(ModLopod,inc_warmup = T)

#What are the parameters calculated in this models?
modelParams(ModLopod)

#Summary statistics for global parameters
lopodSummary(ModLopod, probs = c(0.25,0.5,0.75))

#Plot kernel od global parameters
lopodDens(ModLopod)

#Create a raster with the mean probability of presence (change parameters for other)
meanPsyPlot=lopodShape(ModLopod, param="psy_i", metric="mean", extrapolate = T)

#plot raster
spplot(meanPsyPlot, zcol = "psy_i" )


